class TimetablesController < ApplicationController
  include AttachableController
  load_and_authorize_resource
  before_action :set_user
  before_action :set_job
  before_action :set_timetables
  before_action :set_timetable, only: [:show, :edit, :update, :destroy]
  before_action :set_role, only: [:index]
  respond_to :html, only: [:index]
  respond_to :js, only: [:new, :edit, :create, :update, :destroy]
  respond_to :json, only: [:index, :update]

  before_action do
    add_breadcrumb "<i class='fa fa-table'> #{I18n.t("breadcrumbs.jobs.all")}</i>".html_safe, :jobs_path, :title => I18n.t("breadcrumbs.jobs.return")
    add_breadcrumb "<i class='fa fa-edit'> #{@job.title}</i>".html_safe, edit_job_path(id: @job.id), :title => I18n.t("breadcrumbs.samples.edit")
    add_breadcrumb "<i class='fa fa-table'> #{I18n.t("breadcrumbs.timetables.all")}</i>".html_safe, :job_timetables_path, :title => I18n.t("breadcrumbs.timetables.return")
  end
  # GET /timetables
  # GET /timetables.json
  def index
    @section = 'timetables'
    @modal = params[:modal]
    respond_to do |format|
      format.html do
        @next_id = @timetables.count.to_i + 1
        @section = params[:section] || 'table'
        # add_breadcrumb "<i class='fa fa-table'> #{I18n.t("breadcrumbs.timetables.sections.table")}</i>".html_safe
      end
      format.js
      format.json do
        dt_filter( @timetables )
      end
    end
  end

  def show
    @section = 'timetables'
    respond_to do |format|
      format.html do
        if params[:modal] == "1"
          @modal = params[:modal]
          @title = @timetable.title
          @icon = ("<i class='fa fa-calendar'></i>").html_safe
          render layout: 'modal'
        end
        add_breadcrumb "<i class='fa fa-edit text-trim'> #{ @timetable.title }</i>".html_safe
      end
      format.json do
        render json: @timetable, layout: false
      end
    end
  end

  def new
    @modal = params[:modal]
    @next_id = @timetables.count.to_i + 1
    @timetable = @timetables.new(start_at: l(Date.today), stop_at: l(Date.today + 1.day), author: @user, sortorder: ( @job.timetables.count + 1 ) )
    if @modal == "1"
      @title = @job.title
      @icon = ("<i class='fa fa-calendar-plus-o'></i>").html_safe
      render layout: 'modal'
    end
    add_breadcrumb "<i class='fa fa-plus'> #{I18n.t("breadcrumbs.timetables.new")}</i>".html_safe
  end

  def edit
    @modal = params[:modal]
    if @modal == "1"
      @title = "#{ I18n.t('sortorder', scope: 'timetables.fields', default: 'N° Order') } #{@timetable.sortorder} - #{@timetable.title}"
      @icon = ("<i class='fa fa-calendar'></i>").html_safe
      render layout: 'modal'
    end
    add_breadcrumb "<i class='fa fa-plus'> #{I18n.t("breadcrumbs.timetables.edit")}</i>".html_safe
  end

  # POST /timetables
  # POST /timetables.json
  def create
    @modal = params[:modal]
    @section = params[:section] || 'table'
    @timetable = @timetables.new(timetable_params)
    @timetable.author = current_user.label
    respond_to do |format|
      if @timetable.save
        format.js {
          set_timetables
          @timetable = @timetables.new
        }
        format.json { render :json => {:tid => task.id} }
      else
        # puts @timetable.errors.full_messages.join(', ')
        format.js
        format.json { render json: @timetable.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /timetables/1
  # PATCH/PUT /timetables/1.json
  def update
    @section = params[:section] || 'table'
    @timetable.author = current_user.label
    respond_to do |format|
      if @timetable.update(timetable_params)
        format.js
        format.json {
          id = [@timetable.id]
          new_row = render_to_string('timetables/_timetable.html', :layout => false, :locals => { :timetable => @timetable })
          render :json => { new_row: new_row, id: id, job_id: @job.id, :status => 200 }
        }
      else
        format.js
        format.json { render json: @timetable.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end

  def changeorder
    other_timetable = @timetables.find_by_id( timetable_params_order[:sortorder_to] )
    current_sort = @timetable.sortorder
    @timetable.author = current_user.label
    @timetable.sortorder = other_timetable.sortorder
    other_timetable.update( sortorder: current_sort, author: current_user.label )
    respond_to do |format|
      if @timetable.save
        @timetables = @job.timetables.reorder(sortorder: :asc)
        format.js
      else
        format.js
      end
    end
  end
  # DELETE /timetables/1
  # DELETE /timetables/1.json
  def destroy
    @section = params[:section] || 'table'
    @timetable.author = current_user.label
    respond_to do |format|
      format.js {
        if @timetable.destroy
          set_timetables
          @timetable = @timetables.new(start_at: l(Date.today), stop_at: l(Date.today + 1.day ), author: @user)
        else
          render action: :new
        end
      }
      format.json { render :json => {:status => "ok"} }
    end
  end

  def print
    add_breadcrumb "<i class='fa fa-plus'> #{I18n.t("breadcrumbs.timetables.print")}</i>".html_safe
  end

  def template
    template = params.require( :timetable ).permit(:template)
    case template[:template]
      when 'standard'
        template_for_standard
      when 'radon'
        template_for_radon
    end
    redirect_to job_timetables_path(job_id: @job.id), notice: I18n.t('notice', scope: 'timetables.create', default: 'Timetables was successfully created.')
  end

  private
    def set_user
      @user = current_user
    end

    def set_job
      @job = Job.find(params[:job_id])
    end

    def set_timetables
      @timetables = @job.timetables.order(sortorder: :asc, start_at: :asc, stop_at: :asc)
    end

    def set_timetable
      @timetable = @timetables.find(params[:id])
      @timetable.author = @user.label unless @timetable.blank?
    end

    def timetable_params
      params.require(:timetable).permit(:sortorder, :parent_id, :title, :start_at, :stop_at, :days, :products, :restrict, :execute_at, :body, :closed, :color, :progress )
    end

    def timetable_params_order
      params.require( :timetable ).permit( :sortorder_from, :sortorder_to )
    end

    def template_for_standard
    end

    def template_for_radon
      @job.timetables.create( title: "Preparazione, consegna al cliente: rivelatori CR39 1° periodo di misura, questionario per le abitazioni", start_at: Date.today, stop_at: Date.today + 10.days, products: "Lettera Prot. n………del………" )
      @job.timetables.create( title: "consegna rivelatori 2° periodo di misura;sviluppo chimico rivelatori 1° periodo; letture TASL", start_at: Date.today, stop_at: Date.today + 100.days, products: "Doc Lab TASL …………..Rapporti di analisi n………….del…………….." )
      @job.timetables.create( title: "Sviluppo chimico rivelatori 2° periodo di misura; letture TASL", start_at: Date.today, stop_at: Date.today + 90.days, products: "Doc Lab TASL …………..Rapporti di analisi n………….del…………….." )
      @job.timetables.create( title: 'Stesura lettera invio risultati', start_at: Date.today, stop_at: Date.today + 10.days, products: "Lettera di trasmissione risultati Prot n……………..del…………………." )
    end
end
