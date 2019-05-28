json.extract! log, :id, :created_at, :author
json.created_on I18n.l(log.created_at) unless log.created_at.blank?
json.job do
  json.code log.job.blank? ? '' : log.job.code 
end
json.action I18n.t( 'action', scope: "#{log.loggable_type.downcase.pluralize unless log.loggable_type.blank?}.#{log.action.try(:downcase)}", default: "#{log.action} #{log.loggable_type}" )
values = []
values << log.body
unless log.field.blank? || log.field == '{}'
  values << "<ul class='nop'>"
  log.field.each do |k,v|
    if k != 'metadata' && ( v[0].blank? ? '' : v[0].to_s.strip ) != ( v[1].blank? ? '' : v[1].to_s.strip )
      values << '<li>' + I18n.t( k, scope: ["#{ log.loggable_type.blank? ? '' : log.loggable_type.downcase.pluralize }",'fields'].reject(&:empty?).join('.'), default: k ) + " da #{ v[0].blank? ? 'vuoto' : v[0] } a #{ v[1].blank? ? 'vuoto' : v[1] }" + '</li>'
  	end
  end
  values << "</ul>"
end
json.values values.join(' ').html_safe