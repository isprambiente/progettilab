pdf.stroke_color 0, 0, 0, 100
pdf.bounding_box [pdf.bounds.left, pdf.bounds.top ], :width  => pdf.bounds.width, :height => 70 do
  pdf.image( "#{Rails.root}/app/assets/images/#{ Settings['reportpdf']['logo'] }", :at => [pdf.bounds.left+1, pdf.bounds.top-10], :width => 150, :height => 50 ) if Settings['reportpdf']['logo'].present?
  pdf.text_box "Servizio #{Settings['reportpdf']['subtitle']}", :at => [(pdf.bounds.left+200), pdf.bounds.top-15], :size => 16, style: :bold
  pdf.text_box "Progettazione Proc/Att", :at => [(pdf.bounds.left+200), pdf.bounds.top-40], :size => 16
  pdf.stroke_bounds
end

pdf.move_down(30)

left = pdf.bounds.left
rect_left = pdf.bounds.left
field_left = pdf.bounds.left+5

label_size = @fontsize
text_size = @fontsize-0.5

pdf.line_width = 1
pdf.stroke_color 0, 0, 0, 40

pdf.text_box "ISTITUZIONI COINVOLTE:", :size => label_size, :at => [left, pdf.cursor]
pdf.move_down(15)
pdf.stroke_rectangle [ rect_left, pdf.cursor+5 ], pdf.bounds.width, 80
pdf.text_box "#{job.institutions}", :size => text_size, :at => [field_left, pdf.cursor]

pdf.move_down(95)
pdf.text_box "PERSONALE ASSEGNATO:", :size => label_size, :at => [left, pdf.cursor]
pdf.move_down(15)
pdf.stroke_rectangle [ rect_left, pdf.cursor+5 ], pdf.bounds.width, 80
pdf.text_box "#{job.job_technicians.pluck(:label).join(', ')}", :size => text_size, :at => [field_left, pdf.cursor]

pdf.move_down(95)
pdf.text_box "ULTERIORI RISORSE (COMPETENZE MATERIALI STRUMENTAZIONE ECC):", :size => label_size, :at => [left, pdf.cursor]
pdf.move_down(15)
pdf.stroke_rectangle [ rect_left, pdf.cursor+5 ], pdf.bounds.width, 100
pdf.text_box "#{job.other_resources}", :size => text_size, :at => [field_left, pdf.cursor]

pdf.bounding_box [pdf.bounds.left, 80], :width  => pdf.bounds.width do
  pdf.stroke_color 0, 0, 0, 100
  pdf.stroke do
    line = pdf.horizontal_line 0, pdf.bounds.width, :at => 0
  end
  pdf.move_down(10)
  pdf.text_box "Preparato da:", :size => label_size, :at => [left, pdf.cursor]
  pdf.text_box job.job_managers.first.label, :size => text_size, :at => [pdf.bounds.left+80, pdf.cursor]
  pdf.text_box "Validato da:", :size => label_size, :at => [left+320, pdf.cursor]
  pdf.text_box "#{job.chief.label}", :size => text_size, :at => [left+390, pdf.cursor]

  pdf.move_down(20)
  pdf.text_box "Data:", :size => label_size, :at => [left, pdf.cursor]
  pdf.text_box "____________________________", :size => text_size, :at => [pdf.bounds.left+80, pdf.cursor]
  pdf.text_box "Data:", :size => label_size, :at => [left+320, pdf.cursor]
  pdf.text_box "____________________________", :size => text_size, :at => [left+390, pdf.cursor]

  pdf.move_down(20)
  pdf.text_box "Firma:", :size => label_size, :at => [left, pdf.cursor]
  pdf.text_box "____________________________", :size => text_size, :at => [pdf.bounds.left+80, pdf.cursor]
  pdf.text_box "Firma:", :size => label_size, :at => [left+320, pdf.cursor]
  pdf.text_box "____________________________", :size => text_size, :at => [left+390, pdf.cursor]

end