class Nelou::CreateOrderInvoiceJob < ActiveJob::Base
  queue_as :low

  def perform(*args)
    old_locale = I18n.locale

    order_id = args.first
    order = Spree::Order.find_by(id: order_id)

    return unless order.present?

    I18n.locale = order.user.locale.to_sym if order.user.locale.present?

    Enterprise::OrderService.new(order).save!

    return unless order.sent_to_enterprise

    invoices_dir = Rails.root.join('tmp', 'invoices')
    target_dir = Rails.root.join('lib', 'invoices')

    invoices_dir.mkpath unless invoices_dir.directory?
    target_dir.mkpath unless target_dir.directory?

    host = URI.parse(Rails.application.secrets.enterprise_api_url).hostname

    documents = order.shipments.map do |shipment|
      link = shipment.enterprise_order.invoices.first.documents.first.link

      download_file("http://#{host}#{link}", invoices_dir.join(File.basename(link)))
    end

    target_file = target_dir.join("#{order.number}_#{Time.now.getutc.to_i}_combined.pdf")

    pdf = CombinePDF.new
    pdf << CombinePDF.parse(render_invoice(order))
    documents.each do |file|
      pdf << CombinePDF.load(file)
    end
    pdf.save(target_file)

    order.update_attribute(:invoice_path, target_file.relative_path_from(Rails.root))

    documents.each do |file|
      File.unlink file rescue ''
    end

    I18n.locale = old_locale

    order
  end

  private

  def download_file(src, dest)
    uri = URI.parse(src)

    Net::HTTP.start(uri.hostname) do |http|
      resp = http.get(uri.path)
      open(dest, 'wb') do |file|
        file.write(resp.body)
      end

      dest
    end
  end

  def render_invoice(order)
    order.update_invoice_number!

    order.pdf_file('invoice')
  end
end
