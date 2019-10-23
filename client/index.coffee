
Router.map ->
  @route "signIn",
    path: "/sign-in"



Template.signIn.events
  'click .btn-login-google': (event, template) ->
    Meteor.loginWithGoogle {}, (err) ->
      if err?
        console.log "an error occurred", err
      else 
        Router.go('/')
