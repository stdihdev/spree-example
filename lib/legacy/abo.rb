module Legacy
  class Abo < ActiveRecord::Base
    establish_connection :legacy_nelou
    self.table_name = 'nl_abos'

    def migrate!
      user = Spree::User.find_by(email: email)

      if user.present?
        user.subscribed = aktiv
        # user.save!(validate: false)
      end
    rescue => e
      puts "Problem with #{email}: #{e}"
    end

    def self.migrate_all!
      Legacy::Abo.where(aktiv: true).find_each(&:migrate!)
    end

  end
end
