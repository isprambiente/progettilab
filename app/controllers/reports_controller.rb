class ReportsController < ApplicationController
  before_action :set_job
  before_action :set_report, only: [:show, :edit, :update, :delete, :destroy, :download]

  # GET /reports
  # GET /reports.json
  def index
    @section = params[:section] || 'issued'
    @report_type = params[:report_type]
    @modal = params[:modal] if params[:modal] == "1"
    respond_to do |format|
      format.html do
        add_breadcrumb "<i class='fa fa-table'> #{I18n.t("breadcrumbs.jobs.all")}</i>".html_safe, :jobs_path, :title => I18n.t("breadcrumbs.jobs.return")
        add_breadcrumb "<i class='fa fa-edit text-trim'> #{@job.title}</i>".html_safe, edit_job_path(id: @job.id), :title => I18n.t("breadcrumbs.jobs.edit")
        add_breadcrumb I18n.t(@section, scope: "breadcrumbs.jobs.sections", default: @section)
      end
      format.js
      format.json do
        if @section == 'issued'
          @reports = @job.reports.includes(:types)
          dt_filter( @reports )
        elsif @section == 'cancelled'
          @reports = @job.reports.unscoped.cancelled.includes(:types)
          dt_filter( @reports )
        elsif @section == 'notissued'
          if @report_type == 'multiple'
            @results = @job.results.where.not(id: @job.report_result_ids ).joins(:analisy_type) #.merge( AnalisyType.radon )
            dt_filter( @results )
          elsif @report_type == 'single'
            @analisies = @job.analisies.joins(:type).where( id: @job.results.where.not(id: @job.report_result_ids ).map{|r| r.analisy_id }.uniq )
            dt_filter( @analisies )
          end
        end
      end
    end
  end

  def delete
    @section = 'issued'
    if params[:modal] == "1"
      @modal = params[:modal]
      @icon = ("<i class='fa fa-trash'></i> ")
      @title = "#{t('title', scope: 'reports.destroy', default: "Delete report")} #{ @report.code }"
      render layout: 'modal'
    end
    add_breadcrumb "<i class='fa fa-table'> #{I18n.t("breadcrumbs.jobs.reports")}</i>".html_safe, :job_reports_path
    add_breadcrumb I18n.t(@section, scope: "breadcrumbs.jobs.sections", default: @section)
  end

  # POST /reports
  # POST /reports.json
  def create
    @error_ids = []
    @error_messages = []
    @report_type = report_params[:type]
    @section = params[:section]
    respond_to do |format|
      if @report_type == 'single'
        analisy_ids = report_params[:analisy_ids]
        if analisy_ids.present?
          analisy_ids.each do | analisy_id |
            analisy_id = analisy_id.try(:to_i)
            report = @job.reports.new
            report.analisy_id = analisy_id
            report.author = current_user.label
            report.report_type = @report_type
            report.result_ids = @job.analisies.find( analisy_id ).result_ids
            report.save
            if report.errors.present?
              @error_ids << analisy_id
              @error_messages << report.errors.full_messages.join(', ')
            end
            sleep(1.seconds)
          end
        end
      elsif @report_type == 'multiple'
        result_ids = report_params[:result_ids]
        if result_ids.present?
          report = @job.reports.new
          report.result_ids = result_ids
          report.author = current_user.label
          report.report_type = @report_type
          report.general_body = report_params[:general_body] || ''
          unless report.save
            @error_ids << result_ids
            @error_messages << report.errors.full_messages.join(', ')
          end
        end
      end
      if @error_ids.blank?
        format.html { redirect_to job_reports_path(report_type: @report_type), notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
        format.js
      else
        format.html { render :new }
        format.json { render json: @error_ids, status: :unprocessable_entity }
        format.js
      end
   end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    @section = params[:section]
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @section = params[:section]
    @report.cancellation_reason = report_params[:cancellation_reason]
    @report.cancelled_at = I18n.l Date.today
    @report.author = current_user.label
    @report.destroy
  end

  def download

    if File.exists?(@report.file.path)
      send_file @report.file.path, filename: @report.file_file_name, type: 'application/pdf'
    else
      render :file => "#{Rails.root}/public/file_not_found.html", :status => 500, :layout => false
    end
  end

  private
    def set_job
      @job = Job.find(params[:job_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find_by(job_id: params[:job_id], id: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.fetch(:report, {}).permit(:id, :job_id, :analisy_id, :type, :general_body, :cancelled, :cancellation_reason, analisy_ids: [], result_ids: [], results_attributes: [ :id ] )
    end
end
