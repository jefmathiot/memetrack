Dir.glob(File.join(File.dirname(__FILE__), 'memes', '*.*')).each do |file|
  Meme.create!(
    picture: File.open(file),
    tags: File.basename(file, '.*').split('-')
  )
end
