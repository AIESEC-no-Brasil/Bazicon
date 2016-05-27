##
# Control everything about Session: Login, Logout etc. It also control the initial page
class SessionsController < ApplicationController
  # GET /
  def index
    if session[:expa_id]
      EXPAHelper.auth(session[:mail],session[:pass])
      return redirect_to main_path
    end
    render layout: "empty"
  end

  # POST /
  def login
    mail = params[:email]
    pass = params[:password]
    EXPAHelper.auth(mail, pass)
    if EXPA.client.get_token.nil?
      flash[:notice] = "Invalid Username or Password"
      flash[:color]= "invalid"
      return redirect_to(:action => "index")
    else
      user = ExpaPerson.find_by_xp_email(mail)
      if user.nil?
        user = ExpaPerson.new
        user.update_from_expa(EXPA::CurrentPerson.get_current_person)
      end
      #check if user is from AIESEC in Brazil
      if user.xp_home_mc.xp_id == 1606
	user.save
	reset_session
	session[:expa_id] = user.xp_id
	session[:mail] = mail
	session[:password] = pass
	session[:user_home_lc] = user.xp_home_lc.xp_id
	redirect_to main_path
      else
        flash[:notice] = "BAZICON is only available for AIESEC In Brazil members."
        flash[:color]= "invalid"
        return redirect_to(:action => "index")
      end
    end
  end

  # GET /
  def logout
    reset_session
    redirect_to root_path
  end
end
