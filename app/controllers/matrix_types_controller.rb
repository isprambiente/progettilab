class MatrixTypesController < ApplicationController
  load_and_authorize_resource
  before_action :set_user
  before_action :set_matrix_type, only: [:edit, :update, :destroy]

  before_action do
    add_breadcrumb "<i class='fa fa-gears'> #{I18n.t("breadcrumbs.admin.index")}</i>".html_safe, :admin_path, :title => I18n.t("breadcrumbs.admin.return")
    add_breadcrumb "<i class='fa fa-table'> #{I18n.t("breadcrumbs.admin.matrixtypes.index")}</i>".html_safe, :matrix_types_path, :title => I18n.t("breadcrumbs.admin.matrixtypes.return")
  end

  # GET /matrix_types
  # GET /matrix_types.json
  def index
    searched = matrix_type_params
    respond_to do |format|
      format.html
      format.json do
        @matrix_types = MatrixType.unscoped.joins('LEFT JOIN matrix_types as category ON category.id = matrix_types.pid')
        @matrix_types = @matrix_types.where(pid: params[:pid]) unless params[:pid].blank?
        if searched[:categories] == 'category' 
          @matrix_types = @matrix_types.categories
        elsif searched[:categories] == 'matrix' 
          @matrix_types = @matrix_types.matrices
        end
        dt_filter( @matrix_types )
      end
    end
  end

  # GET /matrix_types/new
  def new
    @categories = MatrixType.categories
    @matrix_type = MatrixType.new
    @new_category = params[:new_category] if [true, false].include?(params[:new_category])
    if params[:modal] == "1"
      @modal = params[:modal]
      @icon = ("<i class='fa fa-plus'></i> ")
      @title = @new_category ? "#{t('category', scope: 'matrixtypes.new', default: 'New category')}" : "#{t('matrix', scope: 'matrixtypes.new', default: 'New matrix')}"
      render layout: 'modal'
    end
    add_breadcrumb "<i class='fa fa-plus'> #{I18n.t("breadcrumbs.admin.matrixtypes.new")}</i>".html_safe
  end

  # GET /matrix_types/1/edit
  def edit
    @categories = MatrixType.categories
    if params[:modal] == "1"
      @modal = params[:modal]
      @icon = ("<i class='fa fa-edit'></i> ")
      if @matrix_type.pid.blank?
        @title = "#{t('category', scope: 'matrixtypes.edit', default: 'Edit category type')}"
      else
        @title = "#{t('title', scope: 'matrixtypes.edit', default: 'Edit matrix type')}"
      end
      render layout: 'modal'
    end
    add_breadcrumb "<i class='fa fa-edit'> #{@matrix_type.title}</i>".html_safe
  end

  # POST /matrix_types
  # POST /matrix_types.json
  def create
    @matrix_type = MatrixType.new(matrix_type_params)
    @matrix_type.author = current_user.label
    respond_to do |format|
      if @matrix_type.save
        format.html { redirect_to @matrix_type, notice: I18n.t('notice', scope: 'matrixtypes.create', default: 'Matrix type was successfully created.') }
        format.js
        format.json { render :show, status: :created, location: @matrix_type }
      else
        format.html { render :new }
        format.js
        format.json { render json: @matrix_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matrix_types/1
  # PATCH/PUT /matrix_types/1.json
  def update
    @matrix_type.author = current_user.label
    respond_to do |format|
      if @matrix_type.update(matrix_type_params)
        format.html { redirect_to @matrix_type, notice: I18n.t('notice', scope: 'matrixtypes.update', default: 'Matrix type was successfully updated.') }
        format.js
        format.json { render :show, status: :ok, location: @matrix_type }
      else
        format.html { render :edit }
        format.js
        format.json { render json: @matrix_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matrix_types/1
  # DELETE /matrix_types/1.json
  def destroy
    @matrix_type.author = current_user.label
    @matrix_type.destroy
    respond_to do |format|
      format.html { redirect_to matrix_types_url, notice: I18n.t('notice', scope: 'matrixtypes.destroy', default: 'Matrix type was successfully destroyed.') }
      format.js
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = current_user  
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_matrix_type
      @matrix_type = MatrixType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def matrix_type_params
      params.fetch(:matrix_type, {}).permit(:pid, :categories, :title, :body, :radia, :active)
    end
end
