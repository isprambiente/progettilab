json.draw @draw
json.recordsTotal @full_count
json.recordsFiltered @filtered_count
json.data do
  json.array! @paginated, partial: 'units/unit', as: :unit
end