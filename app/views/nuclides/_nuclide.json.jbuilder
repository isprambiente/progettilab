json.extract! nuclide, :id, :title, :body, :active, :created_at, :updated_at
json.editable can?(:update, nuclide)
json.deletable can?(:destroy, nuclide)
json.url nuclide_url(id: nuclide.id)