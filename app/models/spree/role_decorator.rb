Spree::Role.class_eval do

  class << self

    def designer_role
      find_or_create_by name: 'designer'
    end

  end

end
