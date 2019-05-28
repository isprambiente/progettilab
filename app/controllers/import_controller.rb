class ImportController < ApplicationController
  load_resource :job
  load_resource :sample
  load_resource :analisy
  load_resource :result
  before_action :set_user
  before_action :set_job

  def index
    @title = ''
    add_breadcrumb "<i class='fa fa-table'> #{I18n.t("breadcrumbs.jobs.all")}</i>".html_safe, :jobs_path, :title => I18n.t("breadcrumbs.jobs.return")
    add_breadcrumb "<i class='fa fa-edit text-trim'> #{@job.title}</i>".html_safe, edit_job_path(id: @job.id), :title => I18n.t("breadcrumbs.jobs.edit")
    add_breadcrumb "<i class='fa fa-upload'> #{I18n.t('title', scope: 'import', default: 'Import files')}</i>".html_safe
    @attachment = Attachment.new
  end

  def template
    render xlsx: 'template', filename: "template_import_#{ l( Time.now, format: '%Y%m%d' ) }.xlsx", disposition: 'inline'
  end

  def verify
    add_breadcrumb "<i class='fa fa-table'> #{I18n.t("breadcrumbs.jobs.all")}</i>".html_safe, :jobs_path, :title => I18n.t("breadcrumbs.jobs.return")
    add_breadcrumb "<i class='fa fa-edit text-trim'> #{@job.title}</i>".html_safe, edit_job_path(id: @job.id), :title => I18n.t("breadcrumbs.jobs.edit")
    add_breadcrumb "<i class='fa fa-upload'> #{I18n.t('title', scope: 'import', default: 'Import files')}</i>".html_safe
    @errors = false
    @nuclides = Nuclide.select( :id, :title )
    @units = Unit.select( :id, :title )
    @attachment = @job.attachments.new(attachment_params)
    if @attachment.valid?
      require 'roo'
      xlsx = Roo::Spreadsheet.open(params[:attachment][:file].tempfile)
      sheet = xlsx.sheet(0)
      rows = params[:attachment][:start] || 2 # !!!!!!!!!!!!!!!!!!!!!!!!! Riga di partenza
      @preimports = []
      sheet.each_row_streaming(offset: 1) do
        sample = ''
        analisy = ''
        analisyresult = ''
        result = { device: '', sample: {}, analisy: {}, result: {} }
        sample = Sample.find_or_initialize_by( job_id: @job.id, device: xlsx.cell(rows, 'A' ) )
        sample.job_id         = @job.id
        sample.device         = xlsx.cell(rows, 'A' )
        sample.client_code    = xlsx.cell(rows, 'B' )
        sample.latitude       = xlsx.cell(rows, 'C' )
        sample.longitude      = xlsx.cell(rows, 'D' )
        sample.start_at       = xlsx.cell(rows, 'E' ).try(:to_date)
        sample.stop_at        = xlsx.cell(rows, 'F' ).try(:to_date)
        sample.accepted_at    = xlsx.cell(rows, 'G' ).try(:to_date)
        sample.type_matrix    = MatrixType.find_by( title: xlsx.cell(rows, 'I' ) ) unless xlsx.cell(rows, 'I' ).blank?
        sample.conservation   = xlsx.cell(rows, 'J' )
        sample.report         = xlsx.cell(rows, 'K' )
        sample.body           = xlsx.cell(rows, 'L' )
        sample.created_by     = current_user.label if sample.new_record?
        sample.updated_by     = current_user.label

        if xlsx.cell(rows, 'M' ).present? && xlsx.cell(rows, 'M' ) != ''
          analisy = Analisy.find_or_initialize_by( sample_id: sample.id, type: AnalisyType.find_by( title: xlsx.cell(rows, 'M' ) ) ) do | a |
            a.sample_id               = sample.id unless sample.blank?
            a.type                    = AnalisyType.find_by( title: xlsx.cell(rows, 'M' ) )
            a.reference_at            = xlsx.cell(rows, 'H' ).try(:to_date)
            a.method                  = xlsx.cell(rows, 'O' )
            a.body                    = xlsx.cell(rows, 'P' )
            a.analisy_chief_users     << sample.job.chief
            a.analisy_headtest_users  << User.find_by( label: xlsx.cell(rows, 'Z' ) ) unless xlsx.cell(rows, 'Z' ).blank?
            a.analisy_technic_user_ids = [ User.find_by( label: xlsx.cell(rows, 'AA' ) ).try(:id), User.find_by( label: xlsx.cell(rows, 'AB' ) ).try(:id), User.find_by( label: xlsx.cell(rows, 'AC' ) ).try(:id) ]
          end

          if xlsx.cell(rows, 'N' ).present? && xlsx.cell(rows, 'N' ) != ''
            analisyresult = AnalisyResult.find_or_initialize_by( analisy_id: analisy.id, nuclide: Nuclide.find_by( title: xlsx.cell(rows, 'N' ) ) ) do | r |
              r.analisy_id              = analisy.id unless analisy.blank?
              r.nuclide                 = Nuclide.find_by( title: xlsx.cell(rows, 'N' ) )
              r.result                  = xlsx.cell(rows, 'Q' )
              r.result_unit             = Unit.find_by( title: xlsx.cell(rows, 'R' ) ) unless xlsx.cell(rows, 'R' ).blank?
              r.symbol                  = '±'
              r.indecision              = xlsx.cell(rows, 'S' )
              r.indecision_unit         = Unit.find_by( title: xlsx.cell(rows, 'T' ) ) unless xlsx.cell(rows, 'T' ).blank?
              r.mcr                     = xlsx.cell(rows, 'U' )
              r.doc_rif_int             = xlsx.cell(rows, 'V' )
              r.info                    = xlsx.cell(rows, 'W' )
              r.body                    = xlsx.cell(rows, 'X' )
              r.absence_analysis        = "#{xlsx.cell(rows, 'Y' )}"
            end
          end
        end


        result[:sample] = sample.serializable_hash.merge( new: sample.new_record? ? true : false, editable: can?( :update, sample ), valid: sample.valid?, errors: sample.errors.messages.map{|k,v| "#{t(k, scope:'samples.fields', default: k)} #{v.join(',')}" }.join(', ') )
        result[:analisy] = analisy.present? ? analisy.serializable_hash.merge( new: analisy.new_record? ? true : false, editable: can?( :update, analisy ), analisy_chief_user_ids: analisy.analisy_chief_user_ids, analisy_headtest_user_ids: analisy.analisy_headtest_user_ids, analisy_technic_user_ids: analisy.analisy_technic_user_ids, valid: analisy.valid?, errors: analisy.errors.messages.map{|k,v| "#{t(k, scope:'analisies.fields', default: k)} #{v.join(',')}" }.join(', ') ) : ''
        result[:result] = analisyresult.present? ? analisyresult.serializable_hash.merge( new: analisyresult.new_record? ? true : false, editable: can?( :update, analisyresult ), valid: analisyresult.valid?, errors: analisyresult.errors.messages.map{|k,v| "#{t(k, scope:'analisyresults.fields', default: k)} #{v.join(',')}" }.join(', ') ) : ''

        @preimports << result
        # @errors = true if analisyresult.present? && analisyresult.invalid?
        rows += 1
      end
      render :index
    else
      render :index
    end
  end

  def create
    # Importa le analisi
    puts 'Importa le analisi'
    @elaborated = 0
    @imported = 0
    @notimported = 0
    @errors = []
    @results = []
    rows = params[:results]
    unless rows.blank?
      rows.each do | key, row |
        result_row = []
        j_sample = ActiveSupport::JSON.decode( row[:sample] ) unless row[:sample].blank?
        j_analisy = ActiveSupport::JSON.decode( row[:analisy] ) unless row[:analisy].blank?
        j_result = ActiveSupport::JSON.decode( row[:result] ) unless row[:result].blank?

        if j_sample.present?
          result_row << j_sample['device']
          sample = @job.samples.find_or_initialize_by( device: j_sample['device'] )
          if can? :update, sample
            sample.attributes = j_sample.except( 'code', 'id', 'created_at', 'updated_at' )
            if sample.save
              result_row << "Import campione OK"
              if j_analisy.present?
                analisy = sample.analisies.find_or_initialize_by( analisy_type_id: j_analisy['analisy_type_id'] )
                if can? :update, analisy
                  analisy.attributes = j_analisy.except( 'code', 'sample_id', 'id', 'created_at', 'updated_at' )
                  if analisy.save
                    result_row << "Import analisi OK"
                    if j_result.present?
                      result = analisy.results.find_or_initialize_by( nuclide_id: j_result['nuclide_id'] )
                      if can? :update, result
                        result.import = true
                        result.attributes = j_result.except( 'analisy_id', 'id', 'created_at', 'updated_at' )
                        if result.save
                          result_row << "Import risultato OK"
                        else
                          result_row << "<span class='text-alert'>" + result.errors.messages.map{ | field, error | "#{ t( field, scope: 'analisyresults.fields', default: field ) } #{ error.join(', ') }" }.join(', ') + "</span>"  # "Import risultato ha generato errore"
                        end
                      else
                        result_row << "Non è possibile aggiornare questo risultato"
                      end
                    end
                  else
                    result_row << "<span class='text-alert'>" + analisy.errors.messages.map{ | field, error | "#{ t( field, scope: 'analisies.fields', default: field ) } #{ error.join(', ') }" }.join(', ') + "</span>"  # "#{j_analisy['analisy_type_id']}: #{ analisy.errors.full_messages.join(', ') }"
                  end
                else
                  result_row << "Non è possibile aggiornare questa analisi"
                end
              end
            else
              result_row << "<span class='text-alert'>" + sample.errors.messages.map{ | field, error | "#{ t( field, scope: 'samples.fields', default: field ) } #{ error.join(', ') }" }.join(', ') + "</span>" # "Non è possibile aggiornare questo campione"
            end
          else
            result_row <<  "Import campione ha generato errore"
          end
        end

        @results << result_row #.join(' || ')
      end

      @attachment = Attachment.new # if @errors.blank?
    end
  end

  private
    def set_user
      @user = current_user
    end

    def set_job
      @job = Job.find(params[:job_id])
    end

    def attachment_params
      params.require(:attachment).permit( :id, :job_code, :title, :body, :file, :_destroy )
    end

end
