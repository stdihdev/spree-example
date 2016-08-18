class ApplicationController < ActionController::Base
  include Spree::Core::ControllerHelpers
  helper Spree::BaseHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
