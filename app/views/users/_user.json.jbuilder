json.extract! user, :id, :username, :label, :email, :technic, :headtest, :chief, :supervisor, :admin, :created_at, :updated_at
json.editable can?(:update, user)
json.deletable can?(:destroy, user)
json.url user_path(id: user.id)