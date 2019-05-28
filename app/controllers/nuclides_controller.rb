class NuclidesController < ApplicationController
  load_and_authorize_resource
  before_action :set_user
  before_action :set_nuclides, only: [ :index ]
  before_action :set_nuclide, only: [:show, :edit, :update, :destroy]

  before_action do
    add_breadcrumb "<i class='fa fa-gears'> #{I18n.t("breadcrumbs.admin.index")}</i>".html_safe, :admin_path, :title => I18n.t("breadcrumbs.admin.return")
    add_breadcrumb "<i class='fa fa-table'> #{I18n.t("breadcrumbs.admin.nuclides.index")}</i>".html_safe, :nuclides_path, :title => I18n.t("breadcrumbs.admin.nuclides.return")
  end

  # GET /nuclides
  # GET /nuclides.json
  def index
    respond_to do |format|
      format.html
      format.json do
        dt_filter( @nuclides )
      end
    end
  end

  # GET /nuclides/1
  # GET /nuclides/1.json
  def show
    add_breadcrumb "<i class='fa fa-edit'> #{I18n.t("breadcrumbs.admin.nuclides.show")}</i>".html_safe
  end

  # GET /nuclides/new
  def new
    @nuclide = Nuclide.new
    if params[:modal] == "1"
      @modal = params[:modal]
      @icon = ("<i class='fa fa-plus'></i> ")
      @title = "#{t('title', scope: 'nuclides.create', default: "Update")}"
      render layout: 'modal'
    end
    add_breadcrumb "<i class='fa fa-plus'> #{I18n.t("breadcrumbs.admin.nuclides.new")}</i>".html_safe
  end

  # GET /nuclides/1/edit
  def edit
    if params[:modal] == "1"
      @modal = params[:modal]
      @icon = ("<i class='fa fa-edit'></i> ")
      @title = "#{t('title', scope: 'nuclides.update', default: "Update")} #{@nuclide.title.upcase}"
      render layout: 'modal'
    end
    add_breadcrumb "<i class='fa fa-edit text-trim'> #{@nuclide.title}</i>".html_safe
  end

  # POST /nuclides
  # POST /nuclides.json
  def create
    @nuclide = Nuclide.new(nuclide_params)
    @nuclide.author = current_user.label
    respond_to do |format|
      if @nuclide.save
        format.html { redirect_to @nuclide, notice: I18n.t('notice', scope: 'nuclides.create', default: 'Nuclide was successfully created.') }
        format.json { render :show, status: :created, location: @nuclide }
        format.js
      else
        format.html { render :new }
        format.json { render json: @nuclide.errors, status: :unprocessable_entity }
        format.js { render :new }
      end
    end
  end

  # PATCH/PUT /nuclides/1
  # PATCH/PUT /nuclides/1.json
  def update
    @nuclide.author = current_user.label
    respond_to do |format|
      if @nuclide.update(nuclide_params)
        format.html { redirect_to @nuclide, notice: I18n.t('notice', scope: 'nuclides.update', default: 'Nuclide was successfully updated.') }
        format.js
        format.json {
          id = [@nuclide.row]
          new_row = render_to_string('nuclides/_nuclide.html', :layout => false, :locals => { :nuclide => @nuclide })
          render :json => { new_row: new_row, id: id, :status => 200 }
        }
        # format.json { render :show, status: :ok, location: @nuclide }
      else
        format.html { render :edit }
        format.js
        format.json { render json: @nuclide.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nuclides/1
  # DELETE /nuclides/1.json
  def destroy
    @nuclide.author = current_user.label
    respond_to do |format|
      if @nuclide.destroy
        format.html { redirect_to nuclides_url, notice: I18n.t('notice', scope: 'nuclides.destroy', default: 'Nuclide was successfully destroyed.') }
        format.js
        format.json { head :no_content }
      else
        format.html { render :index }
        format.json { render json: @nuclide.errors, status: :unprocessable_entity }
        format.js { render :show }
      end
    end
  end

  private
    def set_user
      @user = current_user
    end

    def set_nuclides
      @nuclides = Nuclide.all
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_nuclide
      @nuclide = Nuclide.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def nuclide_params
      params.require(:nuclide).permit( :id, :title, :body, :active )
    end
end
