Spree::Admin::OrdersController.class_eval do

  def index
    params[:q] ||= {}
    params[:q][:completed_at_not_null] ||= '1' if Spree::Config[:show_only_complete_orders_by_default]
    @show_only_completed = params[:q][:completed_at_not_null] == '1'
    params[:q][:s] ||= @show_only_completed ? 'completed_at desc' : 'created_at desc'
    params[:q][:completed_at_not_null] = '' unless @show_only_completed

    @show_only_unshipped = params[:q][:unshipped_eq] == '1'

    # As date params are deleted if @show_only_completed, store
    # the original date so we can restore them into the params
    # after the search
    created_at_gt = params[:q][:created_at_gt]
    created_at_lt = params[:q][:created_at_lt]

    params[:q].delete(:inventory_units_shipment_id_null) if params[:q][:inventory_units_shipment_id_null] == '0'

    if params[:q][:created_at_gt].present?
      params[:q][:created_at_gt] = Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day rescue ''
    end

    if params[:q][:created_at_lt].present?
      params[:q][:created_at_lt] = Time.zone.parse(params[:q][:created_at_lt]).end_of_day rescue ''
    end

    if @show_only_completed
      params[:q][:completed_at_gt] = params[:q].delete(:created_at_gt)
      params[:q][:completed_at_lt] = params[:q].delete(:created_at_lt)
    end

    @collection = Spree::Order.accessible_by(current_ability, :index)

    if @show_only_unshipped
      if spree_current_user.designer?
        @collection = @collection.with_open_shipments_from_designer(spree_current_user.designer_label)
      else
        @collection = @collection.with_open_shipments
      end
    end

    @search = @collection.ransack(params[:q].reject { |k, _v| k.to_s == 'unshipped_eq' })
    @orders = @search.result(distinct: true)
      .joins(bill_address: :country)
      .select("#{Spree::Order.quoted_table_name}.*, #{Spree::Country.quoted_table_name}.name")
      .page(params[:page]).per(params[:per_page] || Spree::Config[:orders_per_page])

    # Restore dates
    params[:q][:created_at_gt] = created_at_gt
    params[:q][:created_at_lt] = created_at_lt
  end

  def show
    load_order

    respond_with(@order) do |format|
      format.pdf do
        if @order.invoice_path
          send_file Rails.root.join(@order.invoice_path),
            type: 'application/pdf', disposition: 'inline'
        else
          @order.update_invoice_number!

          send_data @order.pdf_file(pdf_template_name),
            type: 'application/pdf', disposition: 'inline'
        end
      end
    end
  end

end
