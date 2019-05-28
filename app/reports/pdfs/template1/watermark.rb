module Watermark
  def watermark
		text_box "ANNULLATO il #{ I18n.l Date.today }", :size => 60, character_spacing: 10, :width => bounds.width, :height => bounds.height, :align => :center, :valign => :center, :at => [0, bounds.height], :rotate => 45, :rotate_around => :center
  end
end