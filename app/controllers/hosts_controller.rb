class HostsController < ApplicationController
	respond_to :html, :js
  def index	
	end

  def add_tmp_responsable(host_person_id=params[:host_id])
    host = HostPerson.find(host_person_id)
    host.tmp_responsable_id = session[:expa_id]
    host.save
    redirect_to '/hosts/index'
  end

  def edit_host_phone(host_person_id = params[:host_id], host_person_phone = params[:host_phone])
    host = HostPerson.find(host_person_id)
    host.phone = host_person_phone
    host.save
    redirect_to '/hosts/index'
  end

  def edit_host_email(host_person_id = params[:host_id], host_person_email = params[:host_email])
    host = HostPerson.find(host_person_id)
    host.email = host_person_email
    host.save
    redirect_to '/hosts/index'
  end

  def edit_host_address(host_person_id = params[:host_id], host_person_address = params[:host_address])
    host = HostPerson.find(host_person_id)
    host.email = host_person_email
    host.save
    redirect_to '/hosts/index'
  end
  
end
