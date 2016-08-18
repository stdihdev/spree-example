require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each) do

    stub_request(:get, /ep-stage.traveladshop.com\/api\/v2\/partners\/(\d+).xml/)
      .to_return(status: 200, body: <<-END
        <partner>
          <id>23</id>
          <name>#{Faker::NameDE.name}</name>
        </partner>
      END
      )

    stub_request(:post, /ep-stage.traveladshop.com\/api\/v2\/partners.xml/)
      .to_return(status: 302, body: "stubbed response", headers: { 'Location': 'http://ep-stage.traveladshop.com/api/v2/customers/23/addresses/42.xml' })

    stub_request(:put, /ep-stage.traveladshop.com\/api\/v2\/partners\/(\d+).xml/)
      .to_return(status: 302, body: "stubbed response", headers: { 'Location': 'http://ep-stage.traveladshop.com/api/v2/customers/23/addresses/42.xml' })

    stub_request(:get, /ep-stage.traveladshop.com\/api\/v2\/customers\/(\d+)\/addresses\/(\d+).xml/)
      .to_return(status: 200, body: <<-END
        <address>
          <id type="integer">42</id>
          <primary type="boolean">true</primary>
          <company>#{Faker::Company.name}</company>
          <addition>#{Faker::NameDE.name}</addition>
          <street>#{Faker::AddressDE.street_address}</street>
          <street2></street2>
          <city>#{Faker::AddressDE.city}</city>
          <postcode>#{Faker::AddressDE.zip_code}</postcode>
          <country>#{Faker::AddressDE.country_code}</country>
          <sales-tax-id></sales-tax-id>
        </address>
      END
      )

    stub_request(:post, /ep-stage.traveladshop.com\/api\/v2\/customers\/(\d+)\/addresses.xml/)
      .to_return(status: 302, body: "stubbed response", headers: { 'Location': 'http://ep-stage.traveladshop.com/api/v2/customers/23/addresses/42.xml' })

    stub_request(:put, /ep-stage.traveladshop.com\/api\/v2\/customers\/(\d+)\/addresses\/(\d+).xml/)
      .to_return(status: 302, body: "stubbed response", headers: { 'Location': 'http://ep-stage.traveladshop.com/api/v2/customers/23/addresses/42.xml' })

    stub_request(:get, /ep-stage.traveladshop.com\/api\/v2\/customers\/(\d+)\/contacts\/(\d+).xml/)
      .to_return(status: 200, body: <<-END
        <contact>
          <id type="integer">42</id>
          <primary type="boolean">true</primary>
          <email>#{Faker::Internet.email}</email>
          <name>#{Faker::NameDE.name}</namw>
          <phone>#{Faker::PhoneNumberDE.phone_number}</phone>
          <fax>#{Faker::PhoneNumberDE.phone_number}</fax>
        </contact>
      END
      )

    stub_request(:post, /ep-stage.traveladshop.com\/api\/v2\/customers\/(\d+)\/contacts.xml/)
      .to_return(status: 302, body: "stubbed response", headers: { 'Location': 'http://ep-stage.traveladshop.com/api/v2/customers/23/contacts/42.xml' })

    stub_request(:put, /ep-stage.traveladshop.com\/api\/v2\/customers\/(\d+)\/contacts\/(\d+).xml/)
      .to_return(status: 302, body: "stubbed response", headers: { 'Location': 'http://ep-stage.traveladshop.com/api/v2/customers/23/contacts/42.xml' })

    stub_request(:get, /blog.nelou.com.*feed=json/).to_return(status: 200, body: '{}')
  end
end
