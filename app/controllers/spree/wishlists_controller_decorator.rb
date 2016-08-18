Spree::WishlistsController.class_eval do
  before_action :require_authentication

=begin
  alias_method :orig_default, :default
  def default
    if spree_current_user.present?
      orig_default
    else
      redirect_to spree.login_path
    end
  end
=end

  private

  def require_authentication
    unless spree_current_user.present?
      # setting this in the session allows devise to return us to
      # the original invocation path, once sign up / sign in is complete
      session[:user_return_to] = request.env['PATH_INFO']
      redirect_to spree.login_path and return
    end
  end

end
