module ImportableController
  extend ActiveSupport::Concern

  def initialize
    super
    c_name = controller_name.singularize
    @daddy = "#{c_name}".classify.constantize
  end

  def import
    @daddy_new = @daddy.new
    @daddy_new.attachments.build
    @analisy_types = AnalisyType.all.pluck(:title, :id)
  end

  def preimport
    require 'roo'
    @analisy_types = AnalisyType.all.select(:id, :title)
    xlsx = Roo::Spreadsheet.open(params[:sample][:attachments][:file].tempfile)
    sheet = xlsx.sheet(0)
    @positions = Settings.templates[@daddy.to_s.downcase.pluralize.to_sym].xlsx.positions
    @titles = Settings.templates[@daddy.to_s.downcase.pluralize.to_sym].xlsx.titles
    @names = Settings.templates[@daddy.to_s.downcase.pluralize.to_sym].xlsx.names
    @types = Settings.templates[@daddy.to_s.downcase.pluralize.to_sym].xlsx.types
    @htmlelements = Settings.templates[@daddy.to_s.downcase.pluralize.to_sym].xlsx.html
    rows = 2 # !!!!!!!!!!!!!!!!!!!!!!!!! Riga di partenza
    @newjob = Job.new
    sheet.each_row_streaming(offset: 1) do |row|
      attributes = []
      @daddies = @newjob.send(@daddy.to_s.downcase.pluralize.to_sym)
      daddy = @daddies.new
      if @daddies.find_by_code( xlsx.cell(rows, @positions[0] ) ).present?
        daddy.errors.add :code, 'Questo codice già esiste nel file che stai importando!'
      elsif @job.send(@daddy.to_s.downcase.pluralize.to_sym).find_by_code( xlsx.cell(rows, @positions[0] ) ).present?
        daddy.id = @job.send(@daddy.to_s.downcase.pluralize.to_sym).find_by_code( xlsx.cell(rows, @positions[0] ) ).id
        daddy.errors.add :code, 'Questo codice già esiste nel database!'
      end
      ( 0..(@names.count-1) ).each do |i|
        value = ''
        if @names[i] != 'measure_type'
          if xlsx.cell(rows, @positions[i] ).present?
            if @types[i] == 'string'
              value = xlsx.cell(rows, @positions[i] ).to_s
            elsif @types[i] == 'text'
              value = xlsx.cell(rows, @positions[i] ).to_s
            elsif @types[i] == 'integer'
              value = xlsx.cell(rows, @positions[i] ).to_i
            elsif @types[i] == 'date'
              value = xlsx.cell(rows, @positions[i] ).strftime
            elsif @types[i] == 'datetime'
              value = xlsx.cell(rows, @positions[i] ).strftime
            end
          end
        else
          if xlsx.cell(rows, @positions[i] ).present?
            value = xlsx.cell(rows, @positions[i] ).split(',').map{ |k| @analisy_types.find_by(title: k.strip ).id }.to_s
          end
        end
        daddy.write_attribute("#{@names[i]}".to_sym, value)
      end

      daddy.author = current_user.label
      rows += 1
    end
    render action: :import
  end

  def imported
    @analisy_types = AnalisyType.all.select(:id, :title)
    @positions = Settings.templates[@daddy.to_s.downcase.pluralize.to_sym].xlsx.positions
    @titles = Settings.templates[@daddy.to_s.downcase.pluralize.to_sym].xlsx.titles
    @names = Settings.templates[@daddy.to_s.downcase.pluralize.to_sym].xlsx.names
    @types = Settings.templates[@daddy.to_s.downcase.pluralize.to_sym].xlsx.types
    @htmlelements = Settings.templates[@daddy.to_s.downcase.pluralize.to_sym].xlsx.html
    @newjob = Job.new(daddy_params)
    @newjob.title = 'Temp Job for import'
    @newjob.job_managers << User.unscoped.find_by(username: 'system')
    @newjob.open_at = Time.now
    if @newjob.valid?
      if @job.update(daddy_params)
        redirect_to polymorphic_path([ @job, @daddy ]), success: 'File importato con successo!'
      else
        render action: :import
      end
    else
      render action: :import
    end
  end

  def template
    render xlsx: "template", filename: "#{I18n.t('file', scope: "#{@daddy.to_s.downcase.pluralize}.import", default: "import_#{@daddy.to_s.downcase.pluralize}" )}.xlsx" #, disposition: 'inline'
  end

  private

  def prerequisite
  end

  def daddy_params
    names = Settings.templates[@daddy.to_s.downcase.pluralize.to_sym].xlsx.names
    params.require(:job).permit( :"#{@daddy.to_s.downcase.pluralize}_attributes" => [ :id, :job_id, :author, measure_type: [] ] + names )
  end

end