class OutgoingExchangeController < ApplicationController

  # GET /ogx/dash
  def dash

  end

  # GET /ogx/list
  def list
    # Leads total esse mês
    ExpaPerson.count(xp_created_at: Time.new(Time.new.year, Time.new.month, 1)..Time.now)
    # Leads oGCDP esse mês
    ExpaPerson.count(xp_created_at: Time.new(Time.new.year, Time.new.month, 1)..Time.now, interested_program: ExpaPerson.interested_programs[:global_volunteer])
    # Leads oGIP esse mês
    ExpaPerson.count(xp_created_at: Time.new(Time.new.year, Time.new.month, 1)..Time.now, interested_program: ExpaPerson.interested_programs[:global_talents])
    # Leads por semana esse mês total
    # Leads por dia esse mês total
    # Leads por semana esse mês oGCDP
    # Leads por dia esse mês oGCDP
    # Leads por semana esse mês oGIP
    # Leads por dia esse mês oGIP

    # MA total esse mês
    # MA oGCDP esse mês
    # MA oGIP esse mês
    # MA por semana esse mês total
    # MA por dia esse mês total
    # MA por semana esse mês oGCDP
    # MA por dia esse mês oGCDP
    # MA por semana esse mês oGIP
    # MA por dia esse mês oGIP

    # RE total esse mês
    # RE oGCDP esse mês
    # RE oGIP esse mês
    # RE por semana esse mês total
    # RE por dia esse mês total
    # RE por semana esse mês oGCDP
    # RE por dia esse mês oGCDP
    # RE por semana esse mês oGIP
    # RE por dia esse mês oGIP

    # Leads total mês passado
    ExpaPerson.count(xp_created_at: Time.new(Time.new.year, Time.new.month - 1, 1)..(Time.new(Time.new.year, Time.new.month, 1) - 1))
    # Leads oGCDP mês passado
    ExpaPerson.count(xp_created_at: Time.new(Time.new.year, Time.new.month - 1, 1)..(Time.new(Time.new.year, Time.new.month, 1) - 1), interested_program: ExpaPerson.interested_programs[:global_volunteer])
    # Leads oGIP mês passado
    ExpaPerson.count(xp_created_at: Time.new(Time.new.year, Time.new.month - 1, 1)..(Time.new(Time.new.year, Time.new.month, 1) - 1), interested_program: ExpaPerson.interested_programs[:global_talents])
    # MA oGCDP mês passado
    # MA oGIP mês passado
    # RE oGCDP mês passado
    # RE oGIP mês passado

    # Leads total ano/mês passado
    ExpaPerson.count(xp_created_at: Time.new(Time.new.year - 1, Time.new.month - 1, 1)..(Time.new(Time.new.year - 1, Time.new.month, 1) - 1))
    # Leads oGCDP ano/mês passado
    ExpaPerson.count(xp_created_at: Time.new(Time.new.year - 1, Time.new.month - 1, 1)..(Time.new(Time.new.year - 1, Time.new.month, 1) - 1), interested_program: ExpaPerson.interested_programs[:global_volunteer])
    # Leads oGIP ano/mês passado
    ExpaPerson.count(xp_created_at: Time.new(Time.new.year - 1, Time.new.month - 1, 1)..(Time.new(Time.new.year - 1, Time.new.month, 1) - 1), interested_program: ExpaPerson.interested_programs[:global_talents])
    # MA oGCDP ano/mês passado
    # MA oGIP ano/mês passado
    # RE oGCDP ano/mês passado
    # RE oGIP ano/mês passado

    # EP MA total oGCDP
    # EP RE total oGCDP
    # EP MA total oGIP
    # EP RE total oGIP

    # Numero Lead por mes esse ano total
    for i in 1..Time.new.month
      ExpaPerson.count(xp_created_at: Time.new(Time.new.year, i, 1)..Time.new)
    end
    # Numero Lead por mes esse ano oGCDP
    for i in 1..Time.new.month
      ExpaPerson.count(xp_created_at: Time.new(Time.new.year, i, 1)..Time.new, interested_program: ExpaPerson.interested_programs[:global_volunteer])
    end
    # Numero Lead por mes esse ano oGIP
    for i in 1..Time.new.month
      ExpaPerson.count(xp_created_at: Time.new(Time.new.year, i, 1)..Time.new, interested_program: ExpaPerson.interested_programs[:global_talents])
    end

    # Numero MA por mes esse ano total
    # Numero MA por mes esse ano oGCDP
    # Numero MA por mes esse ano oGIP
    # Numero RE por mes esse ano total
    # Numero RE por mes esse ano oGCDP
    # Numero RE por mes esse ano oGIP


    # Numero Lead por mes ano passado total
    for i in 1..12
      ExpaPerson.count(xp_created_at: Time.new(Time.new.year - 1, i, 1)..Time.new)
    end
    # Numero Lead por mes ano passado oGCDP
    for i in 1..12
      ExpaPerson.count(xp_created_at: Time.new(Time.new.year - 1, i, 1)..Time.new, interested_program: ExpaPerson.interested_programs[:global_volunteer])
    end
    # Numero Lead por mes ano passado oGIP
    for i in 1..12
      ExpaPerson.count(xp_created_at: Time.new(Time.new.year - 1, i, 1)..Time.new, interested_program: ExpaPerson.interested_programs[:global_talents])
    end
    # Numero MA por mes ano passado total
    # Numero MA por mes ano passado oGCDP
    # Numero MA por mes ano passado oGIP
    # Numero RE por mes ano passado total
    # Numero RE por mes ano passado oGCDP
    # Numero RE por mes ano passado oGIP

    @people = filter_list_leads
  end

  # GET /ogx/detail
  def detail

  end

  private

  def filter_list_leads

  end
end