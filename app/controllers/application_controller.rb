class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  # before_filter :validates_logged_user

  # helper_method :validates_logged_user


  #TODO change name
  # def validates_logged_user

  #   @user = ExpaPerson.find_by_xp_id(session[:expa_id]) if session.include?(:expa_id)
  #   # Sometimes when we are in test enviroment, we delete the database but keep the session cookie. This forces the User creation on database on these cases
  #   controllers_to_ignore = ['sessions', 'digital_transformation', 'token']
  #   if @user.nil? && !controllers_to_ignore.include?(params['controller'])
  #     reset_session
  #     return redirect_to main_path
  #   end
  # end
end
