import { Accounts } from '../lib/accounts.coffee';

Accounts.allow(
  insert: (id, object) ->
    return true
  update: (id, change, fieldnames, modifier) ->
    return true
  remove: (id, object) ->
    return true
)