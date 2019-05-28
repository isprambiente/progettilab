module Design
  def design
    start_new_page( :size => 'A4', :layout => :portrait )
    font "OpenSans"

    stroke_color 0, 0, 0, 100
    bounding_box [bounds.left, bounds.top ], :width  => bounds.width, :height => 90 do
      unless Settings['reportpdf']['logo'].blank?
        image( "#{Rails.root}/app/assets/images/#{ Settings['reportpdf']['logo'] }", :at => [bounds.left+1, bounds.top-10], :width => 150, :height => 70 ) if Settings['reportpdf']['logo'].present?
      end
      text_box "#{Settings.reportpdf.subtitle.try(:upcase)}", :at => [(bounds.left+190), bounds.top-10], :size => 12, style: :bold
      # text_box "#{Settings.config.title.upcase}", :at => [(bounds.left+190), bounds.top-45], :size => 12, style: :bold
      text_box "Progettazione".upcase, :at => [(bounds.left+190), bounds.top-65], :size => 12
      stroke_bounds
    end

    move_down(30)

    left = bounds.left
    rect_left = bounds.left
    field_left = bounds.left+5

    label_size = @fontsize
    text_size = @fontsize-0.5

    line_width = 1
    stroke_color 0, 0, 0, 40

    text_box "ISTITUZIONI COINVOLTE:", :size => label_size, :at => [left, cursor]
    move_down(15)
    stroke_rectangle [ rect_left, cursor+5 ], bounds.width, 80
    text_box "#{@job.institutions}", :size => text_size, :at => [field_left, cursor]

    move_down(95)
    text_box "PERSONALE ASSEGNATO:", :size => label_size, :at => [left, cursor]
    move_down(15)
    stroke_rectangle [ rect_left, cursor+5 ], bounds.width, 80
    text_box "#{@job.job_technicians.pluck(:label).join(', ')}", :size => text_size, :at => [field_left, cursor]

    move_down(95)
    text_box "ULTERIORI RISORSE (COMPETENZE MATERIALI STRUMENTAZIONE ECC):", :size => label_size, :at => [left, cursor]
    move_down(15)
    stroke_rectangle [ rect_left, cursor+5 ], bounds.width, 100
    text_box "#{@job.other_resources}", :size => text_size, :at => [field_left, cursor]

    bounding_box [bounds.left, 80], :width  => bounds.width do
      stroke_color 0, 0, 0, 100
      stroke do
        line = horizontal_line 0, bounds.width, :at => 0
      end
      move_down(10)
      text_box "Preparato da:", :size => label_size, :at => [left, cursor]
      text_box "#{@job.job_managers.first.label}", :size => text_size, :at => [bounds.left+80, cursor]
      text_box "Approvato da:", :size => label_size, :at => [left+320, cursor]
      text_box "#{@job.chief.label}", :size => text_size, :at => [left+390, cursor]

      move_down(20)
      text_box "Data:", :size => label_size, :at => [left, cursor]
      text_box "____________________________", :size => text_size, :at => [bounds.left+80, cursor]
      text_box "Data:", :size => label_size, :at => [left+320, cursor]
      text_box "____________________________", :size => text_size, :at => [left+390, cursor]

      move_down(20)
      text_box "Firma:", :size => label_size, :at => [left, cursor]
      text_box "____________________________", :size => text_size, :at => [bounds.left+80, cursor]
      text_box "Firma:", :size => label_size, :at => [left+320, cursor]
      text_box "____________________________", :size => text_size, :at => [left+390, cursor]

    end

    text_box "#{Settings.reportpdf.bottom.design}", :at => [(bounds.left+1), bounds.bottom+10], :size => text_size-1
  end
end