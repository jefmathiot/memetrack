class MemeTrackWorld
  def search_tags(tags)
    within('form') do
      fill_in 'q', with: @tags = tags
      find('.ui.button').click
    end
  end

  def ensure_card(tags)
    expect(page).to have_selector('.green.card', count: 1)
    within('.green.card') do
      expect(page).to have_content(tags)
    end
  end

  def refute_card
    expect(page).to have_selector('.green.card', count: 0)
  end
end

World do
  MemeTrackWorld.new
end
