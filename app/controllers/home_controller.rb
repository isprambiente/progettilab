class HomeController < ApplicationController
  load_resource :job
  before_action :set_user
  before_action :search_params
  before_action :set_jobs, except: [:search, :logs, :historicizes]
  before_action :set_job, only: [:edit]
  before_action :set_role, only: [:edit]
  respond_to :html, only: [:index, :search, :edit, :logs]
  respond_to :json, only: [:index, :logs]
  respond_to :js, only: [:historicizes]

  before_action do
    unless params[:action] == 'admin' || params[:action] == 'logs'
      add_breadcrumb "<i class='fa fa-home'> #{I18n.t("breadcrumbs.jobs.home")}</i>".html_safe, :home_path, :except => %w( logs reports samples analisies historicizes )
    end
  end
  
  def index
    redirect_to jobs_path if @jobs.blank?
    respond_to do |format|
      format.html
      format.json do
        dt_filter( @jobs )
      end
    end
  end

  def admin
    add_breadcrumb "<i class='fa fa-gears'> #{I18n.t("breadcrumbs.admin.index")}</i>".html_safe, :admin_path, :title => I18n.t("breadcrumbs.admin.return")
  end

  def logs
    @nobar = true
    @logs = Log.left_outer_joins(:job)
    respond_to do |format|
      format.html do
        add_breadcrumb "<i class='fa fa-gears'> #{I18n.t("breadcrumbs.admin.index")}</i>".html_safe, :admin_path, :title => I18n.t("breadcrumbs.admin.return")
        add_breadcrumb "<i class='fa fa-history'> #{I18n.t("breadcrumbs.jobs.logs")}</i>".html_safe
      end
      format.json do
        dt_filter( @logs )
      end
    end
  end

  def historicizes
    Log.historicize( current_user )
  end

  def news
    from = params[:from]
    limit = params[:limit]
    news = []
    rows = Log.select(:job_id, :created_at).where("created_at >= ?", from).where("not job_id is null").distinct(:job_id).limit(limit)
    job_ids = rows.map{|r| r.job_id  }.uniq
    job_ids.each do |job_id| 
      news << Log.where(job_id: job_id).first
    end
    @news = news
  end

  private
    def set_user
      @user = current_user
    end

    def set_job
      @job = Job.find(params[:id])
    end

    def set_jobs
      @searched = search_params

      @status = @searched.present? && @searched[:status].present? ? @searched[:status] : 'opened'
      @consolidated = @searched.present? && @searched[:consolidated].present? ? @searched[:consolidated] : ''
      @role = @searched.present? && @searched[:role].present? ? @searched[:role] : ''

      @jobs = @user.jobs

      if @status.present?
        @jobs = @jobs.send(@status)
      end
      if @consolidated.present?
        @jobs = @jobs.where(consolidated: @consolidated)
      end
      if @role == 'manager'
        @jobs = @jobs.managers_list(user_id: @user.id)
      elsif @role == 'technic'
        @jobs = @jobs.technicians_list(user_id: @user.id)
      end

      @jobs = @jobs.distinct

    end

    def search_params
      params.require(:job).permit(:id, :status, :consolidated, :role, :format, :authenticity_token, :_, :locale, :modal, :section, :_method) if params[:job].present?
    end
end
