json.draw @draw
json.recordsTotal @full_count
json.recordsFiltered @filtered_count
json.data do
  json.array! @paginated, partial: 'analisies/analisy', as: :analisy
end