class InstructionsController < ApplicationController
  load_and_authorize_resource
  before_action :set_user
  before_action :set_instruction, only: [:download, :edit, :update, :destroy]

  before_action do
    add_breadcrumb "<i class='fa fa-gears'> #{I18n.t("breadcrumbs.admin.index")}</i>".html_safe, :admin_path, :title => I18n.t("breadcrumbs.admin.return")
    add_breadcrumb "<i class='fa fa-table'> #{I18n.t("breadcrumbs.admin.instructions.index")}</i>".html_safe, :instructions_path, :title => I18n.t("breadcrumbs.admin.instructions.return")
  end

  # GET /instructions
  # GET /instructions.json
  def index
    @instructions = Instruction.all
    respond_to do |format|
      format.html
      format.json do
        dt_filter( @instructions )
      end
    end
  end

  # GET /instructions/new
  def new
    @instruction = Instruction.new
    if params[:modal] == "1"
      @modal = params[:modal]
      @icon = ("<i class='fa fa-plus'></i> ")
      @title = "#{t('title', scope: 'instructions.new', default: "New  instructions")}"
      render layout: 'modal'
    end
    add_breadcrumb "<i class='fa fa-plus'> #{I18n.t("breadcrumbs.admin.instructions.new")}</i>".html_safe
  end

  # GET /instructions/1/edit
  def edit
    if params[:modal] == "1"
      @modal = params[:modal]
      @icon = ("<i class='fa fa-edit'></i> ")
      @title = "#{t('title', scope: 'instructions.update', default: "Update  instructions")}"
      render layout: 'modal'
    end
    add_breadcrumb "<i class='fa fa-edit text-trim'> #{ @instruction.title }</i>".html_safe
  end

  # POST /instructions
  # POST /instructions.json
  def create
    @instruction = Instruction.new(instruction_params)
    @instruction.author = current_user.label
    respond_to do |format|
      if @instruction.save
        format.html { redirect_to instructions_url, notice: I18n.t('notice', scope: 'instructions.create', default: 'Instructions was successfully created.') }
        format.json { render :index, status: :created, location: @instruction }
        format.js
      else
        format.html { render :new }
        format.json { render json: @instruction.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /instructions/1
  # PATCH/PUT /instructions/1.json
  def update
    @instruction.author = current_user.label
    respond_to do |format|
      if @instruction.update(instruction_params)
        format.html { redirect_to instructions_url, notice: I18n.t('notice', scope: 'instructions.update', default: 'Instructions was successfully updated.') }
        format.json { render :index, status: :ok, location: @instruction }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @instruction.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /instructions/1
  # DELETE /instructions/1.json
  def destroy
    @row = @instruction.row
    @instruction.author = current_user.label
    @instruction.destroy
    respond_to do |format|
      format.html { redirect_to instructions_url, notice: I18n.t('notice', scope: 'instructions.destroy', default: 'Instructions was successfully destroyed.') }
      format.json { head :no_content }
      format.js
    end
  end

  def download
    send_file @instruction.file.path
  end

  private
    def set_user
      @user = current_user
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_instruction
      @instruction = Instruction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def instruction_params
      params.require(:instruction).permit(:title, :body, :file, :active)
    end
end
