class WeeklyActivitiesController < ApplicationController

  def index
    @week = DateTime.now.all_week
  end

  def get_current_week
    monday = DateTime.now.beginning_of_week
    activities = UserActivity.select('job_order_id as joid, job_order_activity_id as id, [date] , sum(hours) as hours')
      .joins('inner join job_order_activities joa on job_order_activity_id = joa.id')
      .where('date >= ? and date <= ? and user_id = ?', monday, monday + 7, current_user.id)
      .group('job_order_id')
      .group('job_order_activity_id')
      .group('date')
      .order('job_order_activity_id, date')

    @result = {}
    current_activity = nil
    activities.each do |act|
      if @result[act.id].nil?
        @result[act.id] = {:jid => 0, :hours => [0,0,0,0,0,0,0]};
      end
      @result[act.id][:jid] = act.joid
      @result[act.id][:hours][act.date.wday - 1] = act.hours
    end
    logger.info '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    logger.info @result
    render :json => @result
  end

  def create
    monday = DateTime.now.beginning_of_week
    UserActivity.where('date >= ? and date <= ? and user_id = ?', monday, monday + 7, current_user.id).destroy_all
    activites = params[:weekly_activity][:_json]
    activites.each do |a|
      7.times do |d|
        act = UserActivity.new 
        act.user_activity_type_id = UserActivityType.working_id
        act.job_order_activity_id = a[:activity_id]
        act.user = current_user
        act.date = DateTime.now.beginning_of_week + d
        act.hours = a[:hours][d]        
        act.save
      end
    end
    redirect_to '/user_activites'
  end

end