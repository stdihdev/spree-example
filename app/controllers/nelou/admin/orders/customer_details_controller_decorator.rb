Spree::Admin::Orders::CustomerDetailsController.class_eval do

  def edit
    @order.build_bill_address if @order.bill_address.nil?
    @order.build_ship_address if @order.ship_address.nil?
  end

end
