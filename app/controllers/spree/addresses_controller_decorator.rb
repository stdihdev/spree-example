Spree::AddressesController.class_eval do
  private

  def address_params
    params[:address].permit(:address,
                            :address1,
                            :address2,
                            :city,
                            :company,
                            :country_id,
                            :firstname,
                            :gender,
                            :lastname,
                            :phone,
                            :state_id,
                            :zipcode
                           )
  end
end
