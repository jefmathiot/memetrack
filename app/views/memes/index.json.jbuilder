json.array!(@memes) do |meme|
  json.extract! meme, :id
  json.url meme_url(meme, format: :json)
  json.thumb meme.picture.url(:thumb)
end
