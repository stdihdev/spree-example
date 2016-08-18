module Nelou
  class DesignersController < Spree::StoreController
    def new
      @user = Spree.user_class.new
      @user.spree_roles << Spree::Role.designer_role
      @user.build_bill_address
      @user.build_designer_label
    end

    def create
      @user = Spree.user_class.new(user_params)
      @user.spree_roles << Spree::Role.designer_role
      @user.designer_label.city = @user.bill_address.city
      @user.bill_address.user = @user if @user.bill_address.present?
      @user.subscribed = true # Designers are subscribed, no matter if they want to or not

      if @user.save
        Nelou::ApplicationMailer.notification_mail(@user).deliver_later

        flash[:success] = t('designers.flash.designer_application_successful')
        redirect_to spree.root_path
      else
        flash[:error] = t('designers.flash.designer_application_error')
        render :new
      end
    end

    private

    def user_params
      params.require(:user).permit :email, :password,
        :privacy_and_conditions, :terms_and_services,
        :password_confirmation, designer_label_attributes: [
          :name, :website, :green, :vat, :paypal
        ], bill_address_attributes: [
          :firstname, :lastname, :address1, :address2, :zipcode, :city,
          :country_id, :state_id, :phone, :gender, :company
        ]
    end
  end
end
