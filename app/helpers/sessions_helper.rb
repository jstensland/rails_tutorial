module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # Returns the current logged-in user (if any).
  # if not, returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])
    #this line just returns the current user, unless not yet initiated
    #then in looks for the user and adds it.
    #2 advantages.  
    # 1) returns nil if not found (better than giving an error)
    # 2) only queries the database once.  Afterward just gives the user
      @current_user ||= User.find_by(id: session[:user_id])
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end
  
  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # Logs out the current user.
  def log_out
    forget(current_user) #deletes cookie tokens
    session.delete(:user_id)
    @current_user = nil
  end
  
end