class OgxController < ApplicationController

  # GET /ogx/index
  def index
     #render 'views/ogx/list'
  end

  # GET /ogx/list
  # GET /ogx/list?lc=INTEGER&page=INTEGER&epi=BOOLEAN&ops=BOOLEAN&page=INTEGER
  def list
    if params[:status] == 'open'
      render :json => ExpaPerson.list_open(params[:lc].to_i).epi(params[:epi]).ops(params[:ops]).to_timeline(params[:page].to_i)
    elsif params[:status] == 'applied'
      render :json => ExpaPerson.list_applied(params[:lc].to_i).epi(params[:epi]).ops(params[:ops]).to_timeline(params[:page].to_i)
    elsif params[:status] == 'accepted'
      render :json => ExpaPerson.list_approved(params[:lc].to_i).epi(params[:epi]).ops(params[:ops]).to_timeline(params[:page].to_i)
    elsif params[:status] == 'realizing'
      render :json => ExpaPerson.list_realized(params[:lc].to_i).epi(params[:epi]).ops(params[:ops]).to_timeline(params[:page].to_i)
    elsif params[:status] == 'completed'
      render :json => ExpaPerson.list_completed(params[:lc].to_i).epi(params[:epi]).ops(params[:ops]).to_timeline(params[:page].to_i)
    else
      render :json => ExpaPerson.listing(params[:lc].to_i, params[:status]).epi(params[:epi]).ops(params[:ops]).to_timeline(params[:page].to_i)
    end
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

    lcs += ExpaOffice.select(:id,:xp_id,:xp_name,:xp_full_name).order(:xp_name => 'asc').all

    render json: lcs
  end

  def kpis
    result = {
      open:ExpaPerson.list_open(params[:lc].to_i).this_year2.count,
      applied:ExpaPerson.list_applied(params[:lc].to_i).this_year2.count,
      accepted:ExpaPerson.list_approved(params[:lc].to_i).this_year2.count,
      realized:ExpaPerson.list_realized(params[:lc].to_i).this_year2.count,
      completed:ExpaPerson.list_completed(params[:lc].to_i).this_year2.count,
      other:ExpaPerson.where(xp_home_lc: params[:lc].to_i, xp_status: 5).this_year.count
    }
    result[:open] += result[:applied] + result[:accepted] + result[:realized] + result[:completed] + result[:other]
    result[:applied] += result[:accepted] + result[:realized] + result[:completed]
    result[:accepted] += result[:realized] + result[:completed]
    result[:realized] += result[:completed]

    render json: result
  end
end