ServiceConfiguration.configurations.upsert {service: "google"},
  {$set: {
    clientId: Meteor.settings.oauth.google.clientId
    loginStyle: "popup",
    secret: Meteor.settings.oauth.google.secret
  }}
