module AttachableController
  extend ActiveSupport::Concern

  def attachments
    @daddy = instance_variable_get(("@" + controller_name.singularize).intern)
    @attachments = @daddy.attachments
    respond_to do |format|
      format.html
      format.js
    end
  end

  def attachment_create
    @daddy = instance_variable_get(("@" + controller_name.singularize).intern)
    if @daddy.save(attachment_params)
      redirect_to polymorphic_path( [:attachments, @daddy] ), success: 'File importato con successo!'
    else
      redirect_to polymorphic_path( [:attachments, @daddy] ), alert: "I files non sono stati importati a causa dei seguenti errori: #{ @daddy.errors.full_messages.join('; ') }"
    end

  end

  def attachment_update
    @daddy = instance_variable_get(("@" + controller_name.singularize).intern)
    @attachment = @daddy.attachments.find(params[:file_id])
    @attachment.author = @user.label
    if @attachment.update(attachment_params)
      id = [@attachment.row]
      render :json => { id: id, :status => 200 }
    else
      render json: @attachment.errors.full_messages, :status => :unprocessable_entity
    end
  end

  def attachment_destroy
    @daddy = instance_variable_get(("@" + controller_name.singularize).intern)
    @attachment = @daddy.attachments.find(params[:file_id])
    if @attachment.delete
      @attachments = @daddy.attachments
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def attachment_download
    @daddy = instance_variable_get(("@" + controller_name.singularize).intern)
    @attachment = @daddy.attachments.find(params[:file_id])
    if File.exists? @attachment.file.path
      send_file @attachment.file.path
    else
      render :file => "#{Rails.root}/public/file_not_found.html", :status => 500, :layout => false
    end
  end

  private

  # common prerequisite for any controller
  def prerequisite
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def attachment_params
    params.require(:"#{@daddy.class}".downcase).permit( attachments_attributes: [ :id, :title, :body, :category, :file, :_destroy ] )
  end
end