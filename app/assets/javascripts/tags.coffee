# Target any 'remove' links inside tags with the $(".tag .remove") selector, and
# on a successful response from that link, use jQuery’s parent() and fadeOut()
# functions to find the link’s parent .tag element, and fade it out of the page.

$ ->
  $(".tag .remove").on "ajax:success", ->
    $(this).parent().fadeOut()