module FactoryGirl
  class << self
    def meme_attachment(path)
      File.new(File.join(File.dirname(__FILE__), path))
    end
  end
end

FactoryGirl.define do
  factory :meme do
    picture FactoryGirl.meme_attachment('meme.jpg')
    tags %w(category1 category2)
    factory :invalid_content_type_meme do
      picture FactoryGirl.meme_attachment('meme.txt')
    end
    factory :heavy_picture_meme do
      picture FactoryGirl.meme_attachment('heavy.jpg')
    end
  end
end
