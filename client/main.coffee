import { Accounts } from '../lib/accounts.coffee';

Router.map ->
  @route 'accounts',
    path: '/'
    layoutTemplate: 'layout'
    waitOn: () ->
      Meteor.subscribe('accounts')
    data: () ->
      accounts: Accounts.find()


Router.map ->
  @route 'accountDetails',
    path: '/account/:_id'
    layoutTemplate: 'layout'
    waitOn: () ->
      Meteor.subscribe('accounts')
    data: () ->
      Accounts.findOne(@params._id)