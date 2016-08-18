module ControllerMacros
  def login_customer
    let(:user) { FactoryGirl.create(:confirmed_user) }

    before(:each) do
      login_as(user, :scope => :spree_user)
    end
  end

  def login_designer
    let(:user) { FactoryGirl.create(:designer) }

    before(:each) do
      login_as(user, :scope => :spree_user)
    end
  end
end
