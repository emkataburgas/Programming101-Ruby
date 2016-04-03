module SessionsHelper
  def login(user)
    session[:user_id] = user.id
  end

  def current_user
    if user_id = session[:user_id]
      @current_user ||= User.find_by(id: user_id)
    elsif user_id = cookies[:user_id]
      @current_user ||= User.find_by(id: user_id)
    end
  end

  def logged_in?
    !@current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    forget @current_user
    @current_user = nil
  end

  def remember(user)
    user.remember
    cookies[:user_id] = user.id
    cookies[:remember_digest] = user.remember_digest
  end

  def forget(user)
    user.forget
    cookies[:user_id] = nil
    cookies[:remember_digest] = nil
  end
end