Feature:
  As a parent
  I want to edit an existing picture
  So that I can fix the associated tags

Scenario:
  Given I've uploaded a picture
  When I update the tags
  Then my kids should be able to find the picture with the modified tags
