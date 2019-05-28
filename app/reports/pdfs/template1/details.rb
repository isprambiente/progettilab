module Details
  def details
    start_new_page( :size => 'A4', :layout => :portrait )
    font "OpenSans"

    # watermark
    #if @job.opened?
    #  text_box "BOZZA", :size => 60, character_spacing: 10, :width => bounds.width, :height => bounds.height, :align => :center, :valign => :center, :at => [0, bounds.height], :rotate => 45, :rotate_around => :center
    #end

    stroke_color 0, 0, 0, 100
    bounding_box [bounds.left, bounds.top ], :width  => bounds.width, :height => 90 do
      unless Settings['reportpdf']['logo'].blank?
        image( "#{Rails.root}/app/assets/images/#{ Settings['reportpdf']['logo'] }", :at => [bounds.left+1, bounds.top-10], :width => 150, :height => 70 ) if Settings['reportpdf']['logo'].present?
      end
      text_box "#{Settings.reportpdf.subtitle.try(:upcase)}", :at => [(bounds.left+190), bounds.top-10], :size => 12, style: :bold
      # text_box "#{Settings.config.title.upcase}", :at => [(bounds.left+190), bounds.top-45], :size => 12, style: :bold
      text_box "Anagrafica proc/att".upcase, :at => [(bounds.left+190), bounds.top-65], :size => 12
      stroke_bounds
    end

    move_down(30)

    left = bounds.left
    rect_left = bounds.left+150
    field_left = bounds.left+155

    label_size = @fontsize
    text_size = @fontsize-0.5

    line_width = 1
    stroke_color 0, 0, 0, 40

    text_box "Proc/att:", :size => label_size, :at => [left, cursor]
    # stroke_rectangle [ bounds.left+75, cursor+5 ], bounds.left+45, 20
    text_box "#{@job.code}", :size => text_size, :at => [bounds.left+80, cursor]

    text_box "Ver:", :size => label_size, :at => [left+130, cursor]
    # stroke_rectangle [ bounds.left+155, cursor+5 ], bounds.left+40, 20
    text_box "#{@job.version}", :size => text_size, :at => [bounds.left+160, cursor]

    text_box "SUPPORTO PA:", :size => label_size, :at => [(bounds.right-170), cursor+5]
    image( "#{Rails.root}/app/assets/images/#{ @job.pa_support? ? 'checked' : 'unchecked' }.png", :at => [bounds.right-30, cursor+5], :width => 10, :height => 10 )

    move_down(17)
    text_box "CONSOLIDATO:", :size => label_size, :at => [(bounds.right-170), cursor+5]
    image( "#{Rails.root}/app/assets/images/#{ @job.consolidated? ? 'checked' : 'unchecked' }.png", :at => [bounds.right-30, cursor+5], :width => 10, :height => 10 )

    move_down(25)
    text_box "RESPONSABILI PROC/ATT:", :size => label_size, :at => [left, cursor]
    stroke_rectangle [ rect_left, cursor+5 ], bounds.right-150, 30
    text_box "#{@job.job_managers.pluck(:label).join(', ')}", :size => text_size, :at => [field_left, cursor]

    move_down(35)
    text_box "DATA:", :size => label_size, :at => [left, cursor]
    stroke_rectangle [ rect_left, cursor+5 ], bounds.right-150, 20
    text_box "#{@job.open_on}", :size => text_size, :at => [field_left, cursor]

    move_down(26)
    text_box "OGGETTO:", :size => label_size, :at => [left, cursor]
    stroke_rectangle [ rect_left, cursor+5 ], bounds.right-150, 45
    text_box "#{@job.title}", :size => text_size, :at => [field_left, cursor]

    move_down(50)
    text_box "CLIENTE:", :size => label_size, :at => [left, cursor]
    stroke_rectangle [ rect_left, cursor+5 ], bounds.right-150, 35
    text_box "#{@job.customer}", :size => text_size, :at => [field_left, cursor]

    move_down(40)
    text_box "INDIRIZZO:", :size => label_size, :at => [left, cursor]
    stroke_rectangle [ rect_left, cursor+5 ], bounds.right-150, 30
    text_box "#{@job.address}", :size => text_size, :at => [field_left, cursor]

    move_down(40)
    text_box "PERSONA DI CONTATTO:", :size => label_size, :at => [left, cursor]
    stroke_rectangle [ rect_left, cursor+5 ], bounds.right-150, 20
    text_box "#{@job.contacts.priority.try(:label)}", :size => text_size, :at => [field_left, cursor]

    move_down(30)
    text_box "TELEFONO1:", :size => label_size, :at => [left, cursor]
    stroke_rectangle [ rect_left, cursor+5 ], bounds.right-150, 20
    text_box "#{@job.contacts.priority.try(:tel1)}", :size => text_size, :at => [field_left, cursor]

    move_down(30)
    text_box "TELEFONO2:", :size => label_size, :at => [left, cursor]
    stroke_rectangle [ rect_left, cursor+5 ], bounds.right-150, 20
    text_box "#{@job.contacts.priority.try(:tel2)}", :size => text_size, :at => [field_left, cursor]

    move_down(30)
    text_box "FAX:", :size => label_size, :at => [left, cursor]
    stroke_rectangle [ rect_left, cursor+5 ], bounds.right-150, 20
    text_box "#{@job.contacts.priority.try(:fax)}", :size => text_size, :at => [field_left, cursor]

    move_down(30)
    text_box "CELLULARE:", :size => label_size, :at => [left, cursor]
    stroke_rectangle [ rect_left, cursor+5 ], bounds.right-150, 20
    text_box "#{@job.contacts.priority.try(:cell)}", :size => text_size, :at => [field_left, cursor]

    move_down(30)
    text_box "EMAIL:", :size => label_size, :at => [left, cursor]
    stroke_rectangle [ rect_left, cursor+5 ], bounds.right-150, 30
    text_box "#{@job.contacts.priority.try(:email)}", :size => text_size, :at => [field_left, cursor]

    move_down(40)
    text_box "REQUISITI IN INGRESSO:", :size => label_size, :at => [left, cursor]
    stroke_rectangle [ rect_left, cursor+5 ], bounds.right-150, 60
    text_box "#{@job.requirements}", :size => text_size-1, :at => [field_left, cursor]

    move_down(70)
    text_box "NOTE:", :size => label_size, :at => [left, cursor]
    stroke_rectangle [ rect_left, cursor+5 ], bounds.right-150, 40
    text_box "#{@job.body}", :size => text_size-1, :at => [field_left, cursor]

    move_down(50)
    text_box "ALLEGATI:", :size => label_size, :at => [left, cursor]
    stroke_rectangle [ rect_left, cursor+5 ], bounds.right-150, 30
    text_box "#{@job.attachments.pluck(:title).join(', ')}", :size => text_size-1, :at => [field_left, cursor]

    bounding_box [bounds.left, 75], :width  => bounds.width do
      stroke_color 0, 0, 0, 100
      stroke do
        line = horizontal_line 0, bounds.width, :at => 0
      end
      move_down(10)
      text_box "CHIUSURA PROC/ATT", :size => label_size, :at => [left, cursor]

      move_down(20)
      text_box "RESPONSABILE PROC/ATT", :size => label_size, :at => [left, cursor]
      text_box "Data", :size => text_size, :at => [bounds.left+130, cursor]
      text_box "___/___/______", :size => text_size, :at => [bounds.left+160, cursor]
      text_box "________________________", :size => text_size, :at => [bounds.left+260, cursor]

      move_down(20)
      text_box "RESPONSABILE AREA", :size => label_size, :at => [left, cursor]
      text_box "Data", :size => text_size, :at => [bounds.left+130, cursor]
      text_box "___/___/______", :size => text_size, :at => [bounds.left+160, cursor]
      text_box "________________________", :size => text_size, :at => [bounds.left+260, cursor]


    end

    text_box "#{Settings.reportpdf.bottom.detail}", :at => [(bounds.left+1), bounds.bottom+10], :size => text_size-1
  end
end