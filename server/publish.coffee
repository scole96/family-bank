import { Meteor } from 'meteor/meteor';
import { BankAccounts } from '../lib/bankAccounts.coffee';

Meteor.publish 'bankAccounts', () ->
  if Meteor.user()?.profile.account_ids?
    Meteor.log.debug "Publish bankAccount for minor: #{Meteor.user().profile.name}"
    BankAccounts.find(_id: {$in:Meteor.user().profile.account_ids})
  else if Meteor.user()?
    Meteor.log.debug "Publish bankAccounts for owner: #{Meteor.user().profile.name}"
    BankAccounts.find({owner_id: Meteor.userId()})
