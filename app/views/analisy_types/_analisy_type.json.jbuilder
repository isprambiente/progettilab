json.extract! analisy_type, :id, :title, :radon, :active, :created_at, :updated_at
json.instruction do
	json.id analisy_type.instruction.blank? ? '' : analisy_type.instruction.id
	json.title analisy_type.instruction.blank? ? '' : analisy_type.instruction.title
end
json.editable can?(:update, analisy_type)
json.deletable can?(:destroy, analisy_type) && analisy_type.analisys.blank?
json.url analisy_type_path(id: analisy_type.id)