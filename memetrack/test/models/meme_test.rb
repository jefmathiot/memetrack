require 'test_helper'

class MemeTest < ActiveSupport::TestCase

  it 'validates' do
    FactoryGirl.build(:meme).valid?.must_equal true
  end

  def ensure_invalid(meme, message)
    meme.valid?.must_equal false
    meme.errors.full_messages.include?(message).must_equal true
  end

  it 'does not validate when picture is undefined' do
    meme = FactoryGirl.build(:meme).tap{|meme| meme.picture = nil }
    ensure_invalid meme, "Picture can't be blank"
  end

  it 'does not validate when the picture content-type is invalid' do
    meme = FactoryGirl.build(:invalid_content_type_meme)
    ensure_invalid meme, "Picture is invalid"
  end

  it 'does not validate when the picture is too heavy' do
    meme = FactoryGirl.build(:heavy_picture_meme)
    ensure_invalid meme, "Picture must be in between 0 Bytes and 5 MB"
  end

  describe 'scoping using tags' do

    it 'returns the element if a single tag matches' do
      meme = FactoryGirl.create(:meme)
      Meme.all_tags(['category1']).to_a.must_equal [meme]
    end

    it 'returns the element if all the tags match' do
      meme = FactoryGirl.create(:meme)
      Meme.all_tags(%w(category1 category2)).to_a.must_equal [meme]
    end

    it 'does not return the element if a tag fails to match' do
      meme = FactoryGirl.create(:meme)
      Meme.all_tags(%w(category1 category3)).must_be :empty?
    end

  end

end
