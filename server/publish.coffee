import { Meteor } from 'meteor/meteor';
import { Accounts } from '../lib/accounts.coffee';

Meteor.publish 'accounts', () ->
  Accounts.find({owner_id: Meteor.userId()})
