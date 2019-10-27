
Router.map ->
  @route 'index',
    path: '/'
    action: () ->
      if Meteor.user()?
        Router.go('accounts')
      else
        Router.go('signIn')

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

Template.header.events
  'click .logout': (event, template) ->
    console.log "signout"
    Meteor.logout () ->
      Router.go('signIn')
