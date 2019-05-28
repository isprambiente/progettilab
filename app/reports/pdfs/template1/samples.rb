module Samples
	def samples
		unless @samples.blank?
			@samples.each do |sample|
				sample( sample ) if sample.valid?
			end
		end
	end

	private

	def sample( sample )
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
      text_box "Scheda campione".upcase, :at => [(bounds.left+190), bounds.top-65], :size => 12
			stroke_bounds
		end

		move_down(30)

		left = bounds.left+5
		rect_left = bounds.left+170
		rect_width = bounds.right-180
		field_left = bounds.left+175

		label_size = @fontsize
		text_size = @fontsize-0.5

		line_width = 1
		stroke_color 0, 0, 0, 40

		text_box "CODICE CAMPIONE AREA FISICA:", :size => label_size, :at => [left, cursor]
		stroke_rectangle [ rect_left, cursor+5 ], rect_width, 20
		text_box "#{ sample.code }", :size => text_size, :at => [field_left, cursor]

		move_down(25)
		text_box "PROC/ATT:", :size => label_size, :at => [left, cursor]
		stroke_rectangle [ rect_left, cursor+5 ], rect_width, 45
		text_box "#{sample.job.title}", :size => text_size, :at => [field_left, cursor]

		move_down(50)
		text_box "DIPENDENTE:", :size => label_size, :at => [left, cursor]
		stroke_rectangle [ rect_left, cursor+5 ], rect_width, 20
		text_box "#{sample.created_by}", :size => text_size, :at => [field_left, cursor]

		move_down(25)
		text_box "DATA DI ACCETTAZIONE:", :size => label_size, :at => [left, cursor]
		stroke_rectangle [ rect_left, cursor+5 ], rect_width, 20
		text_box "#{sample.accepted_on}", :size => text_size, :at => [field_left, cursor]

		move_down(25)
		text_box "VERBALE CLIENTE:", :size => label_size, :at => [left, cursor]
		stroke_rectangle [ rect_left, cursor+5 ], rect_width, 20
		text_box "#{sample.report}", :size => text_size, :at => [field_left, cursor]

		move_down(25)
		text_box "CODICE CAMPIONE CLIENTE:", :size => label_size, :at => [left, cursor]
		stroke_rectangle [ rect_left, cursor+5 ], rect_width, 20
		text_box "#{sample.client_code}", :size => text_size, :at => [field_left, cursor]

		move_down(25)
		text_box "LATITUDINE:", :size => label_size, :at => [left, cursor]
		stroke_rectangle [ rect_left, cursor+5 ], rect_width, 20
		text_box "#{sample.latitude}", :size => text_size, :at => [field_left, cursor]

		move_down(25)
		text_box "LONGITUDINE:", :size => label_size, :at => [left, cursor]
		stroke_rectangle [ rect_left, cursor+5 ], rect_width, 20
		text_box "#{sample.longitude}", :size => text_size, :at => [field_left, cursor]

		move_down(25)
		text_box "DATA INIZIO PRELIEVO/ESPOSIZIONE:", :size => label_size, :at => [left, cursor]
		stroke_rectangle [ rect_left, cursor+5 ], rect_width, 20
		text_box "#{sample.start_on}", :size => text_size, :at => [field_left, cursor]

		move_down(25)
		text_box "DATA FINE PRELIEVO/ESPOSIZIONE:", :size => label_size, :at => [left, cursor]
		stroke_rectangle [ rect_left, cursor+5 ], rect_width, 20
		text_box "#{sample.stop_on}", :size => text_size, :at => [field_left, cursor]

		move_down(25)
		text_box "DATA RIFERIMENTO:", :size => label_size, :at => [left, cursor]
		stroke_rectangle [ rect_left, cursor+5 ], rect_width, 20
		text_box "#{sample.accepted_on}", :size => text_size, :at => [field_left, cursor]

		move_down(25)
		text_box "TIPO DI MATRICE:", :size => label_size, :at => [left, cursor]
		stroke_rectangle [ rect_left, cursor+5 ], rect_width, 20
		text_box "#{sample.type_matrix.try(:title)}", :size => text_size, :at => [field_left, cursor]

		move_down(25)
		text_box "CONSERVAZIONE:", :size => label_size, :at => [left, cursor]
		stroke_rectangle [ rect_left, cursor+5 ], rect_width, 20
		text_box "#{sample.conservation}", :size => text_size, :at => [field_left, cursor]

		move_down(30)
		text_box "NOTE:", :size => label_size, :at => [left, cursor]
		stroke_rectangle [ rect_left, cursor+5 ], rect_width, 60
		text_box "#{sample.body}", :size => text_size-1, :at => [field_left, cursor]

		move_down(70)
		stroke_rectangle [ left, cursor+5 ], bounds.width-15, 200

		# Footer
		text_box "#{Settings.reportpdf.bottom.sample}", :at => [(bounds.left+1), bounds.bottom+10], :size => text_size-1
	end
end