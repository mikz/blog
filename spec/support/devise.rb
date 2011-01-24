RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.include Devise::TestHelpers, :type => :view
end

def login_admin
  sign_out :user
  sign_in Factory(:admin)
end