FactoryBot.define do
  factory :package do
    sequence(:name) { |n| "package_#{n}" }
    description { "A test EPS package" }
    license { "MIT" }
    repository { "https://github.com/example/#{name}" }
    authors { [ "someone" ] }
    homepage { nil }
  end
end
