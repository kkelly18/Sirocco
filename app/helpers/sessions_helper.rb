module SessionsHelper
  
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end
  
  def project_sign_in(project)
    cookies[:remember_project] = {value: project.id,
                                  expires: 20.days.from_now.utc}
    self.current_project = project 
  end
  
  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
    project_sign_out
  end
  
  def project_sign_out
    cookies.delete(:remember_project)
    self.current_project = nil
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_remember_token
  end
  
  def current_project=(project)
    @current_project = project
  end
  
  def current_project
    @current_project ||= project_from_remember_project
  end
    
  def signed_in?
    !current_user.nil?
  end

  def signed_into_project?
    !current_project.nil?
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def current_project?(project)
    project == current_project
  end
  
  def authenticate
    deny_access unless signed_in?
  end
  
  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  private
    
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end
    
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
    
    def project_from_remember_project
      cookies[:remember_project] || nil
    end
    
    def store_location
      session[:return_to] = request.fullpath
    end
    
    def clear_return_to
      session[:return_to] = nil
    end
end
