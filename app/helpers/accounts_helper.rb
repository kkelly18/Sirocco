module AccountsHelper

  def sponsorship_status (decorated_sponsorship)
    return nil if !(d = safe(decorated_sponsorship))

    if d.account.suspended? then
      return "Suspended" 
    else
      return "Invited"       if d.invited?
      return "Enrolled"      if d.enrolled?
    end
    return "" #fail silently, TODO unit test
  end


  def sponsorship_commands (decorated_sponsorship)    
    return nil if !(d = safe(decorated_sponsorship))

    if d.account.suspended? then 
      return suspended_sponsorship_commands(d)      
    else
      return invited_sponsorship_commands(d)  if d.invited?
      return enrolled_sponsorship_commands(d) if d.enrolled?
    end

    return [] #fail silently, TODO unit test
    #example return [{command: 'command', text: 'text'}]

  end

  def safe(p)
      return nil if p == nil
      #return nil if d.class != ...    
      return p
  end

  def invited_sponsorship_commands(d)
      return [{:text      => 'Enroll', 
              :controller => 'sponsorships',
              :action     => 'update',
              :id         =>  d.id,
              :command    => 'enroll'}]
  end

  def enrolled_sponsorship_commands(d)
      a = [{:text           =>'Withdraw', 
              :controller => 'sponsorships',
              :action     => 'update',
              :id         => d.id,
              :command    => 'withdraw'}]

      # if User.find(d.user_id).account_admin?(d.account_id)
        if User.find(d.user_id).sponsorships.find_by_account_id(d.account_id).access_admin?
        a << {:text           =>'Suspend', 
                :controller => 'accounts',
                :action     => 'update',
                :id         => d.account_id,
                :command    => 'suspend'}
      end        
      return a
  end

  def suspended_sponsorship_commands(d)
    if User.find(d.user_id).account_admin?(d.account_id)
        return [{:text        => 'Reinstate', 
                :controller => 'accounts',
                :action     => 'update',
                :id         =>  d.account_id,
                :command    => 'reinstate'}]
      end
      return []
  end

  # def account_admin?(d)
  #   User.find(d.user_id).account_admin?(d.account_id)
  # end

end