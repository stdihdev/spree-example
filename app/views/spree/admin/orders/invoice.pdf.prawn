define_grid(columns: 5, rows: 8, gutter: 10)

font_families.update(
 "futura" => {
    :bold        => Rails.root.join('lib', 'fonts', 'futura-bold.ttf'),
    :italic      => Rails.root.join('lib', 'fonts', 'futura-book-oblique.ttf'),
    :bold_italic => Rails.root.join('lib', 'fonts', 'futura-bold-oblique.ttf'),
    :normal      => Rails.root.join('lib', 'fonts', 'futura-book.ttf')
  }
)

# @font_face = Spree::PrintInvoice::Config[:font_face]
@font_face = "futura"
@font_size = Spree::PrintInvoice::Config[:font_size]

# HEADER
repeat(:all) do
  im = asset_path(Spree::PrintInvoice::Config[:logo_path])

  if im && File.exist?(im)
    image im, vposition: :top, height: 40, scale: Spree::PrintInvoice::Config[:logo_scale]
  end

  grid([0,3], [0,4]).bounding_box do
    font @font_face, size: @font_size
    text Spree.t(:invoice_your_order), align: :right, style: :bold, size: 16
    move_down 2
    text Spree.t(:order_number, number: @order.number), align: :right
    #text Spree.t(:invoice_number, number: @order.invoice_number), align: :right
    move_down 2
    text I18n.l(@order.completed_at.to_date), align: :right
  end
end

# CONTENT
grid([1,0], [6,4]).bounding_box do

  font @font_face, size: @font_size

  # address block on first page only
  repeat(lambda { |pg| pg == 1 }) do
    bill_address = @order.bill_address
    ship_address = @order.ship_address

    move_down 2
    address_cell_billing  = make_cell(content: Spree.t(:billing_address), font_style: :bold)
    address_cell_shipping = make_cell(content: Spree.t(:shipping_address), font_style: :bold)

    billing =  "#{bill_address.firstname} #{bill_address.lastname}"
    billing << "\n#{bill_address.address1}"
    billing << "\n#{bill_address.address2}" unless bill_address.address2.blank?
    billing << "\n#{bill_address.zipcode} #{bill_address.city}"
    billing << "\n#{bill_address.country.name}"
    #billing << "\n#{bill_address.phone}"

    shipping =  "#{ship_address.firstname} #{ship_address.lastname}"
    shipping << "\n#{ship_address.address1}"
    shipping << "\n#{ship_address.address2}" unless ship_address.address2.blank?
    shipping << "\n#{ship_address.zipcode} #{ship_address.city}"
    shipping << "\n#{ship_address.country.name}"
    #shipping << "\n#{ship_address.phone}"
    #shipping << "\n\n#{Spree.t(:via, scope: :print_invoice)} #{@order.shipments.first.shipping_method.name}"

    data = [[address_cell_billing, address_cell_shipping], [billing, shipping]]
    table(data, position: :center, column_widths: [261, 261])
  end

  move_down 10

  header = [
    make_cell(content: Spree.t(:item)),
    make_cell(content: Spree.t(:designer)),
    make_cell(content: Spree.t(:options)),
    make_cell(content: Spree.t(:price)),
    make_cell(content: Spree.t(:qty)),
    make_cell(content: Spree.t(:total))
  ]
  data = [header]

  @order.line_items.sort_by { |l| l.product.try(:designer_label).try(:name) }.each do |item|
    next unless item.variant.present?

    row = [
      item.variant.name,
      item.variant.product.designer_label.name,
      item.variant.options_text,
      item.single_display_amount.to_s,
      item.quantity,
      item.display_total.to_s
    ]
    data += [row]
  end

  table(data, header: true, position: :center, column_widths: [171, 90, 91, 62, 43, 65]) do
    row(0).style align: :center, font_style: :bold
    column(0..2).style align: :left
    column(3..6).style align: :right
  end

  # TOTALS
  move_down 10
  totals = []

  # Subtotal
  totals << [make_cell(content: Spree.t(:subtotal)), @order.display_item_total.to_s]

  # Adjustments
  # @order.all_adjustments.eligible.each do |adjustment|
  #   totals << [make_cell(content: adjustment.label), adjustment.display_amount.to_s]
  # end

  # Shipments
  @order.shipments.group_by { |s| s.shipping_method.name }.each do |name, s|
    totals << [make_cell(content: [Spree.t(:shipping), ': ', name].join('')), Spree::Money.new(s.map(&:cost).sum, currency: @order.currency).to_s]
  end

  # Taxes
  # TODO: This is very, very wrong. But it works for now. Fix as soon as it's clear how!
  gross_price = @order.total * (1 / (1 + 0.19))
  net_price = @order.total
  tax = net_price - gross_price

  #totals << [make_cell(content: Spree.t(:gross)), Spree::Money.new(gross_price, currency: @order.currency).to_s]
  #totals << [make_cell(content: Spree.t(:vat_included_in_price)), Spree::Money.new(tax, currency: @order.currency).to_s]

  # Totals
  totals << [make_cell(content: Spree.t(:order_total_gross)), @order.display_total.to_s]

  # Payments
  total_payments = 0.0
  @order.payments.each do |payment|
    next unless payment.state == 'completed'
    totals << [
      make_cell(
        content: Spree.t(:payment_via,
          gateway: (Spree.t(payment.payment_method.name.parameterize, scope: :payment_methods, default: Spree.t(:unprocessed, scope: :print_invoice))),
          number: payment.number,
          date: I18n.l(payment.updated_at.to_date, format: :long),
          scope: :print_invoice)
      ),
      payment.display_amount.to_s
    ]
    total_payments += payment.amount
  end

  table(totals, column_widths: [458, 65]) do
    row(0..6).style align: :right
    column(0).style borders: [], font_style: :bold
  end

  move_down 60
  text Spree.t(:invoice_notice_headline), align: :left, size: @font_size, style: :bold_italic
  move_down 10
  text Spree.t(:invoice_per_designer_notice), align: :left, size: @font_size, style: :italic

  move_down 30
  text Spree::PrintInvoice::Config[:return_message], align: :right, size: @font_size
end

repeat(:all) do
  bounding_box [bounds.left, bounds.bottom + 25], width: bounds.width, height: 40  do
    font @font_face, size: 8
    text "nelou GmbH - Novalisstraße 11 - D-10115 Berlin - www.nelou.com - mail@nelou.com\n", align: :center
    text "Handelsregister: HRB 128494 B - Registergericht: Amtsgericht Charlottenburg - Steuernummer: 30/453/32609\n", align: :center
    text "UID: DE275221414 - Bankverbindung: nelou gmbh - Deutsche Bank - Kontonummer: 270.930.100\n", align: :center
    text "BLZ: 100.700.24 - IBAN: DE19.1007.0024.0270.9301.00 - BIC: DEUTDEDBBER", align: :center
  end
end

# FOOTER
if Spree::PrintInvoice::Config[:use_footer]
  repeat(:all) do
    grid([7,0], [7,4]).bounding_box do

      data  = []
      data << [make_cell(content: Spree.t(:vat, scope: :print_invoice), colspan: 2, align: :center)]
      data << [make_cell(content: '', colspan: 2)]
      data << [make_cell(content: Spree::PrintInvoice::Config[:footer_left],  align: :left),
      make_cell(content: Spree::PrintInvoice::Config[:footer_right], align: :right)]

      table(data, position: :center, column_widths: [270, 270]) do
        row(0..2).style borders: []
      end
    end
  end
end

# PAGE NUMBER
if Spree::PrintInvoice::Config[:use_page_numbers]
  string  = "#{Spree.t(:page, scope: :print_invoice)} <page> #{Spree.t(:of, scope: :print_invoice)} <total>"
  options = {
    at: [bounds.right - 155, 0],
    width: 150,
    align: :right,
    start_count_at: 1,
    color: '000000'
  }
  number_pages string, options
end
