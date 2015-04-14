When(/^I delete the picture$/) do
  within('.green.card', match: :first) do
    click_link 'Destroy'
  end
end

Then(/^no one should be able to see the picture anymore$/) do
  search_tags(@tags)
  refute_card
end
