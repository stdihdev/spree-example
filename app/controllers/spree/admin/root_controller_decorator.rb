Spree::Admin::RootController.class_eval do
  protected

  def admin_root_redirect_path
    main_app.admin_dashboard_path
  end
end
