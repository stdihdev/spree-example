Spree::WishedProductsController.class_eval do
  before_action :require_authentication

  private

  def require_authentication
    unless spree_current_user.present?
      # setting this in the session allows devise to return us to
      # the original invocation path, once sign up / sign in is complete
      session[:spree_user_return_to] = request.fullpath
      redirect_to spree.login_path and return
    end
  end

end
