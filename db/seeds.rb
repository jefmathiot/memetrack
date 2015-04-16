unless Rails.env.test?
  Dir.glob(File.join(File.dirname(__FILE__), 'memes', '*.*')).each do |file|
    puts "Seeding #{file}"
    Meme.create!(
      picture: File.open(file),
      tags: File.basename(file, '.*').split('-')
    )
  end
end
