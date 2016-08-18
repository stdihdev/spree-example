module Nelou
  module SetLocale
    extend ActiveSupport::Concern

    included do
      # Has to be in the included block, because some idiot working on Spree did
      # the very same and that ALWAYS overrides any member methods. Thanks!
      private

      def set_user_language
        I18n.locale = if params.key?(:locale) && SpreeI18n::Config.supported_locales.include?(params[:locale].to_sym)
                        cookies[:locale] = params[:locale].to_sym
                        params[:locale].to_sym
                      elsif cookies.key?(:locale) && SpreeI18n::Config.supported_locales.include?(cookies[:locale].to_sym)
                        cookies[:locale].to_sym
                      elsif http_accept_language.compatible_language_from(SpreeI18n::Config.supported_locales).present?
                        http_accept_language.compatible_language_from(SpreeI18n::Config.supported_locales)
                      elsif respond_to?(:config_locale, true) && !config_locale.blank?
                        config_locale
                      else
                        Rails.application.config.i18n.default_locale || I18n.default_locale
                      end
      end

    end
  end
end
