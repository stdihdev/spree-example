Spree::Admin::UsersController.class_eval do
  def addresses
    if request.put?
      params = user_params
      params[:ship_address_attributes][:user_id] = @user.id if params[:ship_address_attributes].present?
      params[:bill_address_attributes][:user_id] = @user.id if params[:bill_address_attributes].present?

      if @user.update_attributes(params)
        flash.now[:success] = Spree.t(:account_updated)
      end

      render :addresses
    end
  end
end
