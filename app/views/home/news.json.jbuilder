json.status 'ok'
json.items do
  json.array! @news, partial: 'home/news', as: :news
end