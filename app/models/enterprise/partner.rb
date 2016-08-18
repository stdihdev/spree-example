class Enterprise::Partner < Enterprise::Base
  has_many :contacts, class_name: 'Enterprise::Contact'
  has_many :addresses, class_name: 'Enterprise::Address'
end
