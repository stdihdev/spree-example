# @see https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address

module Nelou
  module Legacy
    module Login
      extend ActiveSupport::Concern

      included do
        devise :database_authenticatable, authentication_keys: [:login]
      end

      module ClassMethods
        def find_for_database_authentication(warden_conditions)
          conditions = warden_conditions.dup
          if login = conditions.delete(:login)
            where(conditions.to_h).where(['lower(legacy_username) = :value OR lower(email) = :value', { value: login.downcase }]).first
          elsif conditions.key?(:legacy_username) || conditions.key?(:email)
            where(conditions.to_h).first
          end
        end
      end

      def login=(login)
        @login = login
      end

      def login
        @login || legacy_username || email
      end
    end
  end
end
