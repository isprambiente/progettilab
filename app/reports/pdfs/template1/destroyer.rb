module Destroyer
  def destroyer
		start_new_page( :size => 'A4', :layout => :portrait )
		font "OpenSans"
		stroke_color 0, 0, 0, 100
		bounding_box [bounds.left, bounds.top ], :width  => bounds.width, :height => 70 do
			unless Settings['reportpdf']['logo'].blank?
        image( "#{Rails.root}/app/assets/images/#{ Settings['reportpdf']['logo'] }", :at => [bounds.left+1, bounds.top-10], :width => 150, :height => 70 ) if Settings['reportpdf']['logo'].present?
      end
      text_box "#{Settings.reportpdf.subtitle.try(:upcase)}", :at => [(bounds.left+190), bounds.top-10], :size => 12, style: :bold
      # text_box "#{Settings.config.title.upcase}", :at => [(bounds.left+190), bounds.top-45], :size => 12, style: :bold
			stroke_bounds
		end

		move_down(30)

		left = bounds.left
		rect_left = bounds.left+150
		rect_width = bounds.right-170
		field_left = bounds.left+155

		label_size = @fontsize
		text_size = @fontsize-0.5

		line_width = 1
		stroke_color 0, 0, 0, 40

		text_box "DATA ANNULLAMENTO:", :size => label_size, :at => [left, cursor]
    stroke_rectangle [ rect_left, cursor+5 ], bounds.right-150, 20
    text_box "#{ I18n.l Date.today }", :size => text_size, :at => [field_left, cursor]

    move_down(25)
    text_box "ANNULLATO DA:", :size => label_size, :at => [left, cursor]
    stroke_rectangle [ rect_left, cursor+5 ], bounds.right-150, 20
    text_box "#{ @report.author }", :size => text_size, :at => [field_left, cursor]

		move_down(25)
		text_box "MOTIVO DELL'ANNULLAMENTO:", :size => label_size, :at => [left, cursor]
		stroke_rectangle [ rect_left, cursor+5 ], bounds.right-150, 60
		text_box "#{@report.cancellation_reason}", :size => text_size-1, :at => [field_left, cursor]

    text_box "#{Settings.reportpdf.bottom.destroyer}", :at => [(bounds.left+1), bounds.bottom+10], :size => text_size-1
  end
end