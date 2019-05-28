json.draw @draw
json.recordsTotal @full_count
json.recordsFiltered @filtered_count
json.data do
  json.array! @paginated, partial: 'matrix_types/matrix_type', as: :matrix_type
end