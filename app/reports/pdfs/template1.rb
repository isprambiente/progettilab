class Template1 < Prawn::Document
  def initialize(obj, sections )
    super({ :skip_page_creation => true })
    require 'template1/configurations'
    extend Configurations
    self.configurations
    @job = obj
    @sections = sections
    if sections[:details].present? && sections[:details] == 'true'
      require 'template1/details'
      extend Details
      self.details
    end
    if sections[:design].present? && sections[:design] == 'true'
      require 'template1/design'
      extend Design
      self.design
    end
    if sections[:timetables].present? && sections[:timetables] == 'true'
      require 'template1/timetables'
      extend Timetables
      @timetables = @job.timetables.reorder(sortorder: :asc)
      self.timetables
    end
    if sections[:samples].present? && sections[:samples] == 'true'
      require 'template1/samples'
      extend Samples
      @samples = @job.samples.reorder(code: :asc)
      self.samples
    end

    if sections[:single].present? && sections[:single] == 'true'
      require 'template1/single'
      extend Single
      @report = obj
      @analisy = obj.analisy
      @job = obj.job
      @sample = @analisy.sample
      self.single
    end

    if sections[:multiple].present? && sections[:multiple] == 'true'
      require 'template1/multiple'
      extend Multiple
      @report = obj
      @result_ids = obj.result_ids
      @job = obj.job
      self.multiple
    end

    @pages = page_count
    if sections[:logs].present? && sections[:logs] == 'true'
      require 'template1/logs'
      extend Logs
      @logs = @job.logs.reorder(created_at: :asc)
      self.logs
    end

    if sections[:destroyer].present? && sections[:destroyer] == 'true'
      require 'template1/destroyer'
      extend Destroyer
      @job = obj.job 
      @report = obj
      self.destroyer
    end

    if sections[:watermark].present? && sections[:watermark] == 'true'
      require 'template1/watermark'
      extend Watermark
      @job = obj.job
      @report = obj
      self.watermark
    end
  end
end