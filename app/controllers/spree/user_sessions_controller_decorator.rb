Spree::UserSessionsController.class_eval do
  include Nelou::SetLocale

  private

  def after_sign_in_path_for(resource)
    stored_location_for(resource) ||
      if resource.is_a?(Spree.user_class) && (resource.designer? || resource.admin?)
        main_app.admin_dashboard_path
      else
        super(resource)
      end
  end
end
