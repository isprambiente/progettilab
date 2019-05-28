module Logs
  def logs
    start_new_page( :size => 'A4', :layout => :portrait )
    font "OpenSans"

    # watermark
    #if @job.opened?
    # text_box "BOZZA", :size => 60, character_spacing: 10, :width => bounds.width, :height => bounds.height, :align => :center, :valign => :center, :at => [0, bounds.height], :rotate => 45, :rotate_around => :center
    #end

    #repeat (@pages+1)..page_count, :dynamic => true do
      stroke_color 0, 0, 0, 100
      stroke_bounds
      bounding_box [bounds.left, bounds.top ], :width  => bounds.width, :height => 70 do
        unless Settings['reportpdf']['logo'].blank?
          image( "#{Rails.root}/app/assets/images/#{ Settings['reportpdf']['logo'] }", :at => [bounds.left+1, bounds.top-10], :width => 150, :height => 70 ) if Settings['reportpdf']['logo'].present?
        end
        text_box "#{Settings.reportpdf.subtitle.try(:upcase)}", :at => [(bounds.left+190), bounds.top-10], :size => 12, style: :bold
        # text_box "#{Settings.config.title.upcase}", :at => [(bounds.left+190), bounds.top-35], :size => 12, style: :bold
        text_box "Storico proc/att".upcase, :at => [(bounds.left+190), bounds.top-60], :size => 12
        stroke_bounds
      end
      left = bounds.left
      rect_left = bounds.left+150
      field_left = bounds.left+155

      label_size = @fontsize
      text_size = @fontsize-0.5
      bounding_box [bounds.left, cursor ], :width  => bounds.width, :height => 90 do
        move_down(10)
        text_box "Proc/Att n.  #{@job.code}  Rev. #{@job.revision}", :size => text_size, :at => [left+20, cursor], style: :bold
        move_down(20)
        text_box "Cliente", :size => text_size, :at => [left+20, cursor], style: :bold
        text_box "#{@job.customer}", :size => text_size, :at => [left+60, cursor], width: 250
        move_down(20)
        text_box "Oggetto", :size => text_size, :at => [left+20, cursor], style: :bold
        text_box "#{@job.title}", :size => text_size, :at => [left+60, cursor], width: 350


        text_box "Tipologia proc/att", :size => text_size, :at => [left+330, cursor+15], style: :bold
        text_box "Consolidata", :size => text_size, :at => [left+420, cursor+30], style: :bold
        image( "#{Rails.root}/app/assets/images/#{ @job.consolidated? ? 'checked' : 'unchecked' }.png", :at => [left+500, cursor+30], :width => 10, :height => 10 )

        text_box "Non consolidata", :size => text_size, :at => [left+420, cursor], style: :bold
        image( "#{Rails.root}/app/assets/images/#{ !@job.consolidated? ? 'checked' : 'unchecked' }.png", :at => [left+500, cursor], :width => 10, :height => 10 )

      end
    #end

    rows = []
    rows << [
              { :content => I18n.t( 'created_at', scope: 'logs.fields', default: 'Created at' ), align: :center },
              { :content => I18n.t( 'action', scope: 'logs.fields', default: 'Action' ), align: :justify },
              { :content => I18n.t( 'body', scope: 'logs.fields', default: 'Description' ), align: :center },
              { :content => I18n.t( 'author', scope: 'logs.fields', default: 'Author' ), align: :center }
            ]
    unless @logs.blank?
      @logs.each do |t|
        action = I18n.t( 'action', scope: "#{t.loggable_type.downcase.pluralize unless t.loggable_type.blank?}.#{t.action.try(:downcase)}", default: "#{t.action} #{t.loggable_type}" )
        values = []
        values << t.body
        unless t.field.blank? || t.field == '{}'
          values << "\n"
          t.field.each do |k,v|
            if k != 'metadata' && ( v[0].blank? ? '' : v[0].to_s.strip ) != ( v[1].blank? ? '' : v[1].to_s.strip )
              values << I18n.t( k, scope: ["#{ t.loggable_type.blank? ? '' : t.loggable_type.downcase.pluralize }",'fields'].reject(&:empty?).join('.'), default: k ) + " da #{ v[0].blank? ? 'vuoto' : v[0] } a #{ v[1].blank? ? 'vuoto' : v[1] }" + " \n"
            end
          end
        end
        body = values.join(' ').html_safe

        rows << [ t.created_on, action, body, t.author ]
      end
    else
      rows << [ { :content =>'Nessuna attività registrata',:colspan => 8, align: :center}]
    end
    # bounding_box [bounds.left, cursor ], width: bounds.width do
      table(rows, width: bounds.width, header: true, row_colors: ['e6e6e6', 'ffffff'], :cell_style => { :size => 8, :borders => [:right, :left, :top, :bottom] } ) do
        row(0).style :font_style => :bold
        column(0).style :width => 60, align: :center
        column(1).style :width => 50, align: :center
        column(2).style align: :justify
        column(3).style :width => 65, align: :center
      end
    #end

    repeat (@pages+1)..page_count, :dynamic => true do
      draw_text "Pag. #{page_number.to_i-@pages.to_i} di #{page_count.to_i-@pages.to_i}", :size => @fontsize_footer, :at => [bounds.right-60, bounds.bottom + @fontsize_footer]
    end
  end
end