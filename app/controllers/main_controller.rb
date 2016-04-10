class MainController < ApplicationController
  def index
    @user = ExpaPerson.find_by_xp_id(session[:expa_id])
  end
  
end