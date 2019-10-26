import { BankAccounts } from '../lib/bankAccounts.coffee';

Accounts.onCreateUser (options, user) ->
  console.log "onCreateUser with options: ", options
  console.log "and user: ", user
  
  user.profile = options.profile or {}
  user.profile.email = user.services.google.email.toLowerCase()
  if BankAccounts.findOne({email:user.profile.email})?
    user.profile.account_ids = BankAccounts.find({email:user.profile.email}).map (a) -> a._id
    user.profile.minor_account = true
  else
    user.profile.master_account = true
  user