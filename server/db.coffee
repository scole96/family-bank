import { BankAccounts } from '../lib/bankAccounts.coffee';

BankAccounts.allow(
  insert: (id, account) ->
    console.log "BankAccounts.insert #{id}", account
    if (user=Meteor.users.findOne({'profile.email':  account.email}))?
      Meteor.users.update user._id, $push: {'profile.account_ids': account._id}
    return true
  update: (id, change, fieldnames, modifier) ->
    return true
  remove: (id, object) ->
    return true
)