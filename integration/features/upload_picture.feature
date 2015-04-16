Feature:
  As a parent
  I want to upload a funny picture
  So that my kids LOL

Scenario:
  Given I want to upload a picture
  When I select a file and I add a few tags
  Then my kids should be able to find the new picture

Scenario:
  Given I want to upload a picture
  When I try to upload a file with an unsupported format
  Then I should see an error message
