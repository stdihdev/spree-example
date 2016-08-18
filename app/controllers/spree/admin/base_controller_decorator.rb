Spree::Admin::BaseController.class_eval do

  prepend_before_action :check_accepted

  # To help with debugging authorization failures
  def redirect_unauthorized_access
    exception = $! # Exception is not given as a parameter, so we use Ruby's $! to fetch the last parameter
    Rails.logger.debug "Access denied on action #{exception.action}, subject: #{exception.subject.inspect}"

    super
  end

  private

  def check_accepted
    if spree_current_user && spree_current_user.designer?

      redirect_to spree.root_url, notice: Spree.t(:you_are_not_accepted_yet) unless spree_current_user.designer_label.present? && spree_current_user.designer_label.accepted

    end
  end

end
