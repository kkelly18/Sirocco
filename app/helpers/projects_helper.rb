module ProjectsHelper

def membership_status (decorated_project_asssociation)
  return nil if !(d = safe(decorated_project_asssociation))
 
  if d.project.suspended? then
    return "Suspended" 
  else
    return "Invited"       if d.invited?
    return "Enrolled"      if d.enrolled?
  end
  return "" #fail silently, TODO unit test
end


def membership_commands (decorated_project_asssociation)    
  return nil if !(d = safe(decorated_project_asssociation))

  if d.project.suspended? then 
    return suspended_commands(d)      
  else
    return invited_commands(d)  if d.invited?
    return enrolled_commands(d) if d.enrolled?
  end

  return [] #fail silently, TODO unit test
  #example return [{command: 'command', text: 'text'}]

end

private

  def safe(p)
    return nil if p == nil
    #return nil if d.class != ...    
    return p
  end

  def invited_commands(d)
    return [{:text        => 'Enroll', 
            :controller => 'memberships',
            :action     => 'update',
            :id         =>  d.id,
            :command    => 'enroll'}]
  end

  def enrolled_commands(d)
    a = [{:text           =>'Withdraw', 
      :controller => 'memberships',
      :action     => 'update',
      :id         => d.id,
      :command    => 'withdraw'}]

      if account_admin?(d)
        a << {:text           =>'Suspend', 
          :controller => 'projects',
          :action     => 'update',
          :id         => d.project_id,
          :command    => 'suspend'}
        end        
        return a
      end

      def suspended_commands(d)
        if account_admin?(d)
          return [{:text        => 'Reinstate', 
            :controller => 'projects',
            :action     => 'update',
            :id         =>  d.project_id,
            :command    => 'reinstate'}]
          end
          return []
        end

        def account_admin?(d)
          User.find(d.user_id).account_admin?(d.project.account_id)
        end

end