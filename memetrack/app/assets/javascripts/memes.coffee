$(document).on 'ready page:load', ->
  $('.cards .dimmable.image').dimmer
    on: 'hover'
  setTimeout ->
    $('.ui.message').transition 'slide down', ->
      setTimeout ->
        $('.ui.message').transition 'slide down', ->
          $('.ui.message').remove()
      , 5000
  , 1000
