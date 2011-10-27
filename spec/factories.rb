Factory.define :user do |u|
 u.sequence(:name) {|n| "Faux User#{n}" }
 u.sequence(:email) {|n| "fauxuser#{n}@keltex.com" }
 u.password "foobar"
 u.password_confirmation  { |p| p.password }
 u.personal_account_name  "Personal Account"
 u.after_build {|user| user.send(:initialize_state_machines, :dynamic => :force)}
end

Factory.define :account do |a|
 a.sequence(:name) {|n| "Faux Account#{n}" }
 a.created_by 1
 a.after_build {|user| user.send(:initialize_state_machines, :dynamic => :force)}
end

Factory.define :project do |p|
  p.sequence(:name) {|n| "Faux Project#{n}" }
  p.created_by   1
  p.account_id   1
  p.after_build {|user| user.send(:initialize_state_machines, :dynamic => :force)}
end

Factory.define :sponsorship do | s |
  s.created_by  1
  s.after_build {|user| user.send(:initialize_state_machines, :dynamic => :force)}
end

Factory.define :membership do | m |
  m.created_by  1
  m.after_build {|user| user.send(:initialize_state_machines, :dynamic => :force)}
end

# Factory.define :project_with_membership, :parent => :project do |project|
#   project.after_create { |p| Factory(:membership, :user_id => p.created_by, :project_id => p.id, :created_by => p.created_by) }
# end

