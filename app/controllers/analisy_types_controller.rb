class AnalisyTypesController < ApplicationController
  load_and_authorize_resource
  before_action :set_user
  before_action :set_analisy_types
  before_action :set_analisy_type, only: [:show, :edit, :update, :destroy]

  before_action do
    add_breadcrumb "<i class='fa fa-gears'> #{I18n.t("breadcrumbs.admin.index")}</i>".html_safe, :admin_path, :title => I18n.t("breadcrumbs.admin.return")
    add_breadcrumb "<i class='fa fa-users'> #{I18n.t("breadcrumbs.admin.analisy_types.index")}</i>".html_safe, :analisy_types_path, :title => I18n.t("breadcrumbs.admin.analisy_types.return")
  end

  # GET /analisy_types
  # GET /analisy_types.json
  def index
    @page = params[:page]
    respond_to do |format|
      format.html
      format.json do
        @analisy_types = @analisy_types.left_outer_joins(:instruction)
        dt_filter( @analisy_types )
      end
    end
  end

  # GET /analisy_types/1
  # GET /analisy_types/1.json
  def show
    add_breadcrumb "<i class='fa fa-edit'> #{I18n.t("breadcrumbs.admin.analisy_types.show")}</i>".html_safe
  end

  # GET /analisy_types/new
  def new
    @page = params[:page] || 'table'
    @analisy_type = AnalisyType.new
    @istructions = Instruction.all
    if params[:modal] == "1"
      @modal = params[:modal]
      @icon = ("<i class='fa fa-plus'></i> ")
      @title = "#{t('title', scope: 'analisytypes.new', default: "New analisy's type")}"
      render layout: 'modal'
    end
    add_breadcrumb "<i class='fa fa-plus'> #{I18n.t("breadcrumbs.admin.analisy_types.new")}</i>".html_safe
  end

  # GET /analisy_types/1/edit
  def edit
    @istructions = Instruction.all
    @page = params[:page] || 'table'
    if params[:modal] == "1"
      @modal = params[:modal]
      @icon = ("<i class='fa fa-edit'></i> ")
      @title = "#{t('title', scope: 'analisytypes.edit', default: "Edit analisy's type")}"
      render layout: 'modal'
    end
    add_breadcrumb "<i class='fa fa-edit text-trim'> #{ @analisy_type.title }</i>".html_safe
  end

  # POST /analisy_types
  # POST /analisy_types.json
  def create
    @page = params[:page] || 'table'
    @analisy_type = AnalisyType.new(analisy_type_params)
    @analisy_type.author = current_user.label
    @istructions = Instruction.all
    respond_to do |format|
      if @analisy_type.save
        format.html { redirect_to @analisy_type, notice: I18n.t('notice', scope: 'analisytypes.create', default: 'Analisy type was successfully created.') }
        format.js
        format.json { render :show, status: :created, location: @analisy_type }
      else
        format.html { render :new }
        format.js
        format.json { render json: @analisy_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /analisy_types/1
  # PATCH/PUT /analisy_types/1.json
  def update
    @page = params[:page] || 'table'
    @analisy_type.author = current_user.label
    @istructions = Instruction.all
    respond_to do |format|
      if @analisy_type.update(analisy_type_params)
        format.html { redirect_to @analisy_type, notice: I18n.t('notice', scope: 'analisytypes.update', default: 'Analisy type was successfully updated.') }
        format.js
        format.json {
          id = [@analisy_type.row]
          new_row = render_to_string('analisy_types/_analisy_type.html', :layout => false, :locals => { :analisy_type => @analisy_type })
          render :json => { new_row: new_row, id: id, :status => 200 }
        }
      else
        format.html { render :edit }
        format.js
        format.json { render json: @analisy_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /analisy_types/1
  # DELETE /analisy_types/1.json
  def destroy
    @page = params[:page] || 'table'
    @analisy_type.author = current_user.label
    @analisy_type.destroy
    respond_to do |format|
      format.html { redirect_to analisy_types_url, notice: I18n.t('notice', scope: 'analisytypes.destroy', default: 'Analisy type was successfully destroyed.') }
      format.js
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = current_user
    end

    def set_analisy_types
      @analisy_types = AnalisyType.all
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_analisy_type
      @analisy_type = @analisy_types.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def analisy_type_params
      params.require(:analisy_type).permit( :id, :instruction_id, :title, :radon, :body, :active, :nuclide_id, nuclide_ids: [] )
    end

end
