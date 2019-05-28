class UnitsController < ApplicationController
  load_and_authorize_resource
  before_action :set_user
  before_action :set_unit, only: [:edit, :update, :destroy]

  before_action do
    add_breadcrumb "<i class='fa fa-gears'> #{I18n.t("breadcrumbs.admin.index")}</i>".html_safe, :admin_path, :title => I18n.t("breadcrumbs.admin.return")
    add_breadcrumb "<i class='fa fa-table'> #{I18n.t("breadcrumbs.admin.units.index")}</i>".html_safe, :units_path, :title => I18n.t("breadcrumbs.admin.units.return")
  end

  # GET /units
  # GET /units.json
  def index
    @units = Unit.all
    respond_to do |format|
      format.html
      format.json do
        dt_filter( @units )
      end
    end
  end

  # GET /units/new
  def new
    @unit = Unit.new
    if params[:modal] == "1"
      @modal = params[:modal]
      @icon = ("<i class='fa fa-plus'></i> ")
      @title = t('title', scope: 'units.new', default: 'New unit')
      render layout: 'modal'
    end
    add_breadcrumb "<i class='fa fa-plus'> #{I18n.t("breadcrumbs.admin.units.new")}</i>".html_safe
  end

  # GET /units/1/edit
  def edit
    if params[:modal] == "1"
      @modal = params[:modal]
      @icon = ("<i class='fa fa-edit'></i> ")
      @title = "#{t('title', scope: 'units.update', default: "Update")} #{@unit.title.upcase}".html_safe
      render layout: 'modal'
    end
    add_breadcrumb "<i class='fa fa-edit'> #{@unit.body}</i>".html_safe
  end

  # POST /units
  # POST /units.json
  def create
    @unit = Unit.new(unit_params)
    @unit.author = current_user.label
    respond_to do |format|
      if @unit.save
        format.html { redirect_to @unit, notice: I18n.t('notice', scope: 'units.create', default: 'Unit was successfully created.') }
        format.js
        format.json { render :show, status: :created, location: @unit }
      else
        format.html { render :new }
        format.js
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /units/1
  # PATCH/PUT /units/1.json
  def update
    @unit.author = current_user.label
    respond_to do |format|
      if @unit.update(unit_params)
        format.html { redirect_to @unit, notice: I18n.t('notice', scope: 'samples.update', default: 'Sample was successfully updated.') }
        format.js
        format.json { render :show, status: :ok, location: @unit }
      else
        format.html { render :edit }
        format.js
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /units/1
  # DELETE /units/1.json
  def destroy
    @unit.destroy
    respond_to do |format|
      format.html { redirect_to units_url, notice: I18n.t('notice', scope: 'samples.destroy', default: 'Sample was successfully destroyed.') }
      format.js
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = current_user  
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = Unit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unit_params
      params.require(:unit).permit(:title, :html, :body, :radon_type, :active)
    end
end
