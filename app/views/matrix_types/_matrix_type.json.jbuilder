json.extract! matrix_type, :id, :pid, :title, :body, :radia, :active, :created_at, :updated_at
unless matrix_type.pid.blank?
  json.category do
		json.extract! matrix_type.category, :id, :pid, :title, :body, :radia, :active
  end
end
json.editable can?(:update, matrix_type)
json.deletable can?(:destroy, matrix_type)
json.url matrix_type_path(id: matrix_type.id)