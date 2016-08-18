Spree::LocaleController.class_eval do

  def set
    params[:locale] ||= I18n.default_locale

    cookies[:locale] = { value: params[:locale].to_sym, expires: Time.now + 20.years }

    respond_to do |format|
      format.json { render json: true }
      format.html { redirect_to root_path }
    end
  end

end
