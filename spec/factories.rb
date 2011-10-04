Factory.define :user do |u|
 u.sequence(:name) {|n| "Faux User#{n}" }
 u.sequence(:email) {|n| "fauxuser#{n}@keltex.com" }
 u.password "foobar"
 u.password_confirmation  { |p| p.password }
end