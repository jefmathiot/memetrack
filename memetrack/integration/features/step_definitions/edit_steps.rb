Given(/^I've uploaded a picture$/) do
  step 'I want to upload a picture'
  step 'I select a file and I add a few tags'
end

When(/^I update the tags$/) do
  within('.green.card', match: :first) do
    click_link 'Edit'
  end
  fill_in 'meme[tags]', with: @tags = MemeTrack.random_tags
  click_button 'Update Meme'
  expect(page).to have_content 'The tags were successfully updated'
end

Then(/^my kids should be able to find the picture with the modified tags$/) do
  search_tags(@tags)
  ensure_card(@tags)
end
