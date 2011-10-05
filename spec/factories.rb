Factory.define :user do |u|
 u.sequence(:name) {|n| "Faux User#{n}" }
 u.sequence(:email) {|n| "fauxuser#{n}@keltex.com" }
 u.password "foobar"
 u.password_confirmation  { |p| p.password }
 u.personal_account_name  "Personal Account"
end

Factory.define :account do |a|
 a.sequence(:name) {|n| "Faux Account#{n}" }
 a.created_by 1
end