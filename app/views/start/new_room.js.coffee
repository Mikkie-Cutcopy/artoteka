history.pushState('', '', "new_room")
sign_up = $('.container.sign_up_popup').html()
$('div.popup-container > div.popup-content').remove()
$('div.popup-container').append(sign_up)