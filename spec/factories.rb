Factory.sequence :user do |user|
  user.sequence(:name)  { |n| "Faux User#{n}" }
  user.sequence(:email) { |n| "fauxuser#{n}.com" }
end  