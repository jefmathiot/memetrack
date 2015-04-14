Given(/^I'm on the memes list$/) do
  visit '/'
end

Given(/^I search for tags$/) do
  search_tags('docker, devops')
end

Then(/^I should see the image I was looking for$/) do
  ensure_card('docker, devops')
end
