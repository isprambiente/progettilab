json.draw @draw
json.recordsTotal @full_count
json.recordsFiltered @filtered_count
json.data do
  if @section == 'notissued'
    if @report_type == 'multiple'
      json.array! @paginated, partial: 'multiple', as: :result
    elsif @report_type == 'single'
      json.array! @paginated, partial: 'single', as: :analisy
    end
  else
    json.array! @paginated, partial: @section, as: :report
  end
end