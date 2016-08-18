# @see https://github.com/plataformatec/devise/wiki/How-To:-Migration-legacy-database

module Nelou
  module Legacy
    module Password
      extend ActiveSupport::Concern

      included do
        before_save :reset_legacy_password
      end

      def valid_password?(password)
        if legacy_password_hash.present?
          if ::Digest::MD5.hexdigest(password) == legacy_password_hash
            #self.password = password
            #self.legacy_password = nil
            #self.legacy_password_hash = nil
            #self.save!
            true
          else
            false
          end
        elsif legacy_password.present?
          if password == legacy_password
            #self.password = password
            #self.legacy_password = nil
            #self.legacy_password_hash = nil
            #self.save!
            true
          else
            false
          end
        else
          super(password)
        end
      end

      def reset_password(*args)
        self.legacy_password_hash = nil
        self.legacy_password = nil
        super(*args)
      end

      protected

      def reset_legacy_password
        if password.present?
          legacy_password_hash_will_change!
          legacy_password_will_change!

          self.legacy_password_hash = nil
          self.legacy_password = nil

          true
        end
      end

      def password_required?
        legacy_password_hash.present? || legacy_password.present? ? false : super
      end
    end
  end
end
