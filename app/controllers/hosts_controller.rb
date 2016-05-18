class HostsController < ApplicationController
	def index	
	end

  def add_tmp_responsable(host_person_id=params[:host_id])
    host = HostPerson.find(host_person_id)
    host.tmp_responsable_id = session[:expa_id]
    host.save
    redirect_to '/hosts/index'
  end
end
