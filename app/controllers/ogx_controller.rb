class OgxController < ApplicationController

  # GET /ogx/index
  def index
    render 'layouts/disrupt'
  end

  # GET /ogx/list
  # GET /ogx/list?lc=INTEGER&page=INTEGER&epi=BOOLEAN&ops=BOOLEAN&page=INTEGER
  def list
    result = ExpaPerson.listing(params[:lc].to_i, params[:status]).epi(params[:epi]).ops(params[:ops]).to_timeline(params[:page].to_i)
    render :json => result
  end

  # GET /ogx/detail?id=INTEGER
  def detail
    return redirect_to main_path unless params.include?('id')

    EXPAHelper.auth(ENV['ROBOZINHO_EMAIL'],ENV['ROBOZINHO_PASSWORD'])
    @person = ExpaPerson.find_by_xp_id(params['id'])
    if @person.nil?
      return redirect_to main_path
    else
      begin
        @person.update_from_expa(EXPA::People.find_by_id(params['id']))
        @person.save
      rescue => exception
        puts exception
        return redirect_to main_path
      end
    end

    generate_program_product_array
    prepare_custom_fields(@person)
  end

  def my_lcs
    lcs = []

    lcs << @user.xp_home_mc unless !( @user.get_role == ExpaPerson.roles[:role_mc] )
    lcs << @user.xp_home_lc

    hash_entities_expa = DigitalTransformation.hash_entities_expa
    hash_entities_expa.delete('nil')
    hash_entities_expa.delete('Comitê Local')

    hash_entities_expa.each do |lc_name, xp_id|
      lcs << { xp_id: xp_id, xp_name: lc_name }
    end

    render json: lcs
  end

  def kpis
    result = {
      open:ExpaPerson.where(xp_home_lc: params[:lc].to_i, xp_status: 0).this_year.count,
      applied:ExpaPerson.where(xp_home_lc: params[:lc].to_i, xp_status: 1).this_year.count,
      accepted:ExpaPerson.where(xp_home_lc: params[:lc].to_i, xp_status: 2).this_year.count,
      realized:ExpaPerson.where(xp_home_lc: params[:lc].to_i, xp_status: 3).this_year.count,
      completed:ExpaPerson.where(xp_home_lc: params[:lc].to_i, xp_status: 4).this_year.count,
      other:ExpaPerson.where(xp_home_lc: params[:lc].to_i, xp_status: 5).this_year.count
    }
    result[:open] += result[:applied] + result[:accepted] + result[:realized] + result[:completed] + result[:other]
    result[:applied] += result[:accepted] + result[:realized] + result[:completed]
    result[:accepted] += result[:realized] + result[:completed]
    result[:realized] += result[:completed]

    render json: result
  end
end