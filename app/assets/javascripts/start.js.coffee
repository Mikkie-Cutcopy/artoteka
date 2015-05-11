# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  start_popup = $('.container.start_popup').html()
  $('div.popup-container').append(start_popup)

$(document).on 'click', '.create_room', ->
  sign_up = $('.container.sign_up_popup').html()
  $('div.popup-container > div.popup-content').remove()
  $('div.popup-container').append(sign_up)