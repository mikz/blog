FactoryGirl.define do
  factory :user do
    nickname 'user'
    email "user@example.com"
    admin true
  end

  # This will use the User class (Admin would have been guessed)
  factory :admin, :class => User do
    nickname 'Admin'
    email "admin@example.com"
    admin true
  end
end