Given(/^I want to upload a picture$/) do
  visit '/memes/new'
end

When(/^I select a file and I add a few tags$/) do
  fill_in 'meme[tags]', with: @tags = MemeTrack.random_tags.join(', ')
  attach_file 'meme[picture]', File.absolute_path('resources/systemd.jpg')
  click_button 'Create Meme'
end

Then(/^my kids should be able to find the new picture$/) do
  expect(URI.parse(current_url).path).to eq('/memes')
  expect(page).to have_content 'The image was successfully saved'
  within('.green.card', match: :first) do
    expect(page).to have_content('systemd.jpg')
    expect(page).to have_content(@tags)
  end
end

When(/^I try to upload a file with an unsupported format$/) do
  attach_file 'meme[picture]',
              File.absolute_path('resources/unsupported_file.txt')
  click_button 'Create Meme'
end

Then(/^I should see an error message$/) do
  expect(page).to have_content 'Unable to save the image'
  within('.field', match: :first) do
    expect(page).to have_content('is invalid')
  end
end
