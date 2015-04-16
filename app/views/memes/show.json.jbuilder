json.extract! @meme, :id, :created_at, :updated_at
json.picture do
  json.original @meme.picture.url
  json.thumb @meme.picture.url(:thumb)
end
