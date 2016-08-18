Spree::Zone.class_eval do

  def self.world
    Spree::Zone.find_or_create_by(name: 'World') do |z|
      z.name = 'World'
      z.description = 'Entire World'
      z.default_tax = true
      Spree::Country.all.find_each { |c| z.countries << c }
    end
  end

end
