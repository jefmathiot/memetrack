Feature:
  As a parent
  I want to delete an existing picture
  So that I can fix my errors

Scenario:
  Given I've uploaded a picture
  When I delete the picture
  Then no one should be able to see the picture anymore
