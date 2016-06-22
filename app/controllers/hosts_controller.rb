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

  def set_favourite(host_person_id = params[:host_id])
    host = HostPerson.find(host_person_id)
    host.is_favourite = true
    host.is_problematic = false
    host.is_non_grata = false
    host.save
    redirect_to '/hosts/index'
  end

  def set_problematic(host_person_id = params[:host_id])
    host = HostPerson.find(host_person_id)
    host.is_problematic = true
    host.is_favourite = false
    host.is_non_grata = false
    host.save
    redirect_to '/hosts/index'
  end


  def set_non_grata(host_person_id = params[:host_id])
    host = HostPerson.find(host_person_id)
    host.is_non_grata = true
    host.is_favourite = false
    host.is_favourite = false
    host.save
    redirect_to '/hosts/index'
  end
  #TODO
  def set_date_approach(host_person_id = params[:host_id], host_date_approach = params[:host_approach])
    redirect_to '/hosts/index'
  end
end
