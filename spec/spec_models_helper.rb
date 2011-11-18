def create_user
  Factory(:user)
end

def create_account (current_user)
  Factory(:account, :created_by => current_user.id)
end

def create_sponsorship(account, user, current_user)
  Factory(:sponsorship,
  :user_id    => user.id,
  :account_id => account.id,
  :created_by => current_user.id,
  :current_user_id => current_user.id)
end

def create_sponsored_project(account, current_user)
  Factory(:project, 
  :account_id => account.id, 
  :created_by => current_user.id)
end

def create_membership(project, user, current_user)  
  Factory(:membership, 
  :user_id    => user.id, 
  :project_id => project.id,
  :created_by => current_user.id,
  :current_user_id => current_user.id)
end

def promote_to_admin(membership)
  membership.promote_access if membership.access_observer?
  membership.promote_access if membership.access_contributor?
end
