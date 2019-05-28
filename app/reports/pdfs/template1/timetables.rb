module Timetables
  def timetables
    start_new_page( :size => 'A4', :layout => :landscape )
    font "OpenSans"

    # watermark
    #if @job.opened?
    #  text_box "BOZZA", :size => 60, character_spacing: 10, :width => bounds.width, :height => bounds.height, :align => :center, :valign => :center, :at => [0, bounds.height], :rotate => 45, :rotate_around => :center
    #end

    stroke_color 0, 0, 0, 100
    stroke_bounds
    bounding_box [bounds.left, bounds.top ], :width  => bounds.width, :height => 90 do
      unless Settings['reportpdf']['logo'].blank?
        image( "#{Rails.root}/app/assets/images/#{ Settings['reportpdf']['logo'] }", :at => [bounds.left+1, bounds.top-10], :width => 150, :height => 70 ) if Settings['reportpdf']['logo'].present?
      end
      text_box "#{Settings.reportpdf.subtitle.try(:upcase)}", :at => [(bounds.left+190), bounds.top-10], :size => 12, style: :bold
      # text_box "#{Settings.config.title.upcase}", :at => [(bounds.left+190), bounds.top-35], :size => 12, style: :bold
      text_box "Programmazione attività / esecuzione".upcase, :at => [(bounds.left+190), bounds.top-60], :size => 12
      text_box "#{Settings.reportpdf.bottom.timetable}", :at => [(bounds.left+570), bounds.top-75], :size => 8
      stroke do
        line = horizontal_line 0, bounds.width, :at => 0
      end
    end
    left = bounds.left
    rect_left = bounds.left+150
    field_left = bounds.left+155

    label_size = @fontsize
    text_size = @fontsize-0.5
    bounding_box [bounds.left, cursor ], :width  => bounds.width, :height => 90 do
      move_down(10)
      text_box "Proc/Att n.  #{@job.code}        Rev. #{@job.revision}", :size => text_size, :at => [left+20, cursor], style: :bold
      move_down(20)
      text_box "Cliente", :size => text_size, :at => [left+20, cursor], style: :bold
      text_box "#{@job.customer}", :size => text_size, :at => [left+60, cursor]
      move_down(20)
      text_box "Oggetto", :size => text_size, :at => [left+20, cursor], style: :bold
      text_box "#{@job.title}", :size => text_size, :at => [left+60, cursor], width: 350


      text_box "Tipologia proc/att", :size => text_size, :at => [left+500, cursor+15], style: :bold
      text_box "Consolidata", :size => text_size, :at => [left+610, cursor+30], style: :bold
      image( "#{Rails.root}/app/assets/images/#{ @job.consolidated? ? 'checked' : 'unchecked' }.png", :at => [left+700, cursor+30], :width => 10, :height => 10 )

      text_box "Non consolidata", :size => text_size, :at => [left+610, cursor], style: :bold
      image( "#{Rails.root}/app/assets/images/#{ !@job.consolidated? ? 'checked' : 'unchecked' }.png", :at => [left+700, cursor], :width => 10, :height => 10 )

    end


    rows = []
    rows << [
      { :content => 'PROGETTAZIONE', align: :center, colspan: 5 },
      { :content => 'ESECUZIONE', align: :center, colspan: 2, width: 250 },
    ]
    rows << [
              { :content => 'Fase', align: :center, width: 30 },
              { :content => 'Oggetto attività', align: :justify },
              { :content => 'Da', align: :center, width: 60 },
              { :content => 'A', align: :center, width: 60 },
              { :content => 'Prodotti', align: :left },
              { :content => 'Data fine esecuzione', align: :center, width: 50 },
              { :content => 'Note', align: :left }
            ]
    unless @timetables.blank?
      @timetables.each do |t|
        rows << [ t.sortorder, t.title, t.start_on, t.stop_on, t.products, t.execute_on, t.body ]
      end
    else
      rows << [ { :content =>'Nessuna attività programmata',:colspan => 7, align: :center}]
    end

    table(rows, width: bounds.width, header: true, row_colors: ['e6e6e6', 'ffffff'], :cell_style => { :size => 8, :borders => [:right, :left, :top, :bottom] } ) do
      row(0).style :font_style => :bold
      row(1).style :font_style => :bold
      column(0).style align: :center
      column(1).style align: :justify
      column(2).style align: :center
      column(3).style align: :center
      column(4).style align: :justify
      column(5).style align: :center
      column(6).style align: :justify
    end
  end
end