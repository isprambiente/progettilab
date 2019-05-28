json.extract! unit, :id, :title, :html, :body, :active, :created_at, :updated_at
json.editable can?(:update, unit)
json.deletable can?(:destroy, unit)
json.url unit_path(id: unit.id)