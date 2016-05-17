class MainController < ApplicationController
  def index

  end

  def force_update
    ExpaRdSync.new.list_applications
    ExpaRdSync.new.list_people
  end
  
end