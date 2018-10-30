class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  helper_method :current_user
  helper_method :categories
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def require_no_user
    redirect_to '/' if current_user
  end
  
  def require_user
    redirect_to '/admin' unless current_user
  end
  
  def require_editor
    redirect_to '/' unless current_user.editor?
  end
  
  def require_admin
    redirect_to '/' unless current_user.admin?
  end

  def categories
    @categories = Category.all.take(10)
  end
end
