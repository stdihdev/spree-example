Spree::OrdersController.class_eval do
  respond_to :pdf, only: :invoice
  before_action :load_order, only: :invoice

  def invoice
    respond_with(@order) do |format|
      format.pdf do
        if @order.invoice_path
          send_file Rails.root.join(@order.invoice_path),
            type: 'application/pdf', disposition: "attachment; filename=#{@order.number}.pdf"
        else
          @order.update_invoice_number!

          send_data @order.pdf_file(pdf_template_name),
            type: 'application/pdf', disposition: "attachment; filename=#{@order.number}.pdf"
        end
      end
    end
  end

  # @see https://github.com/spree/spree/blob/master/frontend/app/controllers/spree/orders_controller.rb#L41
  # Adds a new item to the order (creating a new order if none already exists)
  def populate
    order    = current_order(create_order_if_necessary: true)
    variant  = Spree::Variant.find(params[:variant_id])
    quantity = params[:quantity].to_i
    options  = params[:options] || {}

    # 2,147,483,647 is crazy. See issue #2695.
    if variant.can_supply?(quantity) && quantity.between?(1, 2_147_483_647) # Only line changed from original
      begin
        order.contents.add(variant, quantity, options)
      rescue ActiveRecord::RecordInvalid => e
        error = e.record.errors.full_messages.join(", ")
      end
    else
      error = Spree.t(:please_enter_reasonable_quantity, quantity: quantity)
    end

    if error
      flash[:error] = error
      redirect_back_or_default(spree.root_path)
    else
      respond_with(order) do |format|
        format.html { redirect_to cart_path }
      end
    end
  end

  private

  def load_order
    @order = Spree::Order.includes(line_items: [variant: [:option_values, :images, :product]], bill_address: :state, ship_address: :state).find_by_number!(params[:id])
  end

  def pdf_template_name
    pdf_template_name = params[:template] || 'invoice'
    if !Spree::PrintInvoice::Config.print_templates.include?(pdf_template_name)
      raise Spree::PrintInvoice::UnsupportedTemplateError.new(pdf_template_name)
    end
    pdf_template_name
  end
end
