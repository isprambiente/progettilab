json.extract! instruction, :id, :title, :body, :file, :active, :created_at, :updated_at
json.DT_RowId "tr_#{instruction.id}"
json.file_name instruction.file_file_name
json.editable can?(:update, instruction)
json.deletable can?(:destroy, instruction) && instruction.analisy_types.blank?
json.url instruction_url(id: instruction.id)