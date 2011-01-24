FactoryGirl.define do
  factory :post do
    title "A post"
    body "Post body..."
    published_at 1.year.ago
  end
end
  