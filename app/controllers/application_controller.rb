faceclass ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :validates_logged_user, :except => :sessions

  helper_method :validates_logged_user
  #TODO change name
  def validates_logged_user
    @user = ExpaPerson.find_by_xp_id(session[:expa_id])
    # Sometimes when we are in test enviroment, we delete the database but keep the session cookie. This forces the User creation on database on these cases
    if @user.nil?
      reset_session
      redirect_to index_path
      return
    end
  end

end
