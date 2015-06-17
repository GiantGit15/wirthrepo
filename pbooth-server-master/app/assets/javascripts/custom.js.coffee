# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


#jQuery ->
#
#  $(".photo-frame").on 'click', (event) ->
#    console.log "hello"
#    $(@).toggleClass "selected"
#    console.log $(@)
#    console.log "goodbye"

    #jQuery ->
    #  return $.ajax({
    #url: 'https://apis.google.com/js/client:plus.js?onload=gpAsyncInit',
    #dataType: 'script',
    #cache: true
    #})

#window.gpAsyncInit = ->
# $('.googleplus-login').click( (e) ->
#    e.preventDefault()
#    gapi.auth.authorize({
#      immediate: true,
#      response_type: 'code',
#      cookie_policy: 'single_host_origin',
#      client_id: '000000000000.apps.googleusercontent.com',
#      scope: 'email profile'
#    }, (response) ->
#      if (response && !response.error)
#        # google authentication succeed, now post data to server and handle data securely
#        jQuery.ajax({type: 'POST', url: "/auth/google_oauth2/callback", dataType: 'json', data: response, success: (json) ->
#            # response from server
#        })
#      else
#        # google authentication failed
#    #  
#    )
#      )
