import { Accounts } from '../lib/accounts.coffee';
import 'bootstrap/dist/js/bootstrap.bundle';
import { _ } from 'underscore';

userSignedIn = (router) ->
  unless Meteor.loggingIn()
    unless Meteor.user() 
      Router.go 'signIn'
  router.next?() if router?
  return true

Router.map ->
  @route 'accounts',
    path: '/'
    layoutTemplate: 'mainLayout'
    onBeforeAction: ->
      userSignedIn(this)
    waitOn: () ->
      Meteor.subscribe('accounts')
    data: () ->
      accounts: Accounts.find()

Router.map ->
  @route 'addAccount',
    path: '/addAccount'
    layoutTemplate: 'mainLayout'
    onBeforeAction: ->
      userSignedIn(this)


Template.addAccount.events
  'submit form': (event, template) ->
    event.preventDefault()
    account = processForm event.currentTarget
    account.create_date = new Date()
    account.balance = 0
    account.owner_id = Meteor.userId()
    Accounts.insert account
    Router.go '/'

Router.map ->
  @route 'accountDetails',
    path: '/account/:_id'
    layoutTemplate: 'detailsLayout'
    waitOn: () ->
      Meteor.subscribe('accounts')
    data: () ->
      Accounts.findOne(@params._id)


UI.registerHelper 'formatCurrency', (n) ->
  formatCurrency(n)

@formatCurrency = (n) ->
  if n? and not isNaN(n) and isFinite(n)
    numeral(n/100).format('$0,0.00')

UI.registerHelper 'reverse', (list) ->
  list.reverse() if list?
UI.registerHelper 'formatDate', (date) ->
  moment(date).format("MMM D, YYYY") if date?
UI.registerHelper 'formatDateTime', (date) ->
  moment(date).format("MMM D, YYYY h:mm a") if date?
UI.registerHelper 'getTodaysDate', () ->
  moment().format("YYYY-MM-DD")
UI.registerHelper 'formatCurrency', (n) ->
  if n? and not isNaN(n) and isFinite(n)
    numeral(n/100).format('$0,0[.]00')

Router.map ->
  @route 'deposit',
    path: '/account/:_id/deposit'
    layoutTemplate: 'detailsLayout'
    waitOn: () ->
      Meteor.subscribe('accounts')
    data: () ->
      Accounts.findOne(@params._id)

Router.map ->
  @route 'withdraw',
    path: '/account/:_id/withdraw'
    layoutTemplate: 'detailsLayout'
    waitOn: () ->
      Meteor.subscribe('accounts')
    data: () ->
      Accounts.findOne(@params._id)

Template.deposit.events
  'submit form': (event, template) ->
    event.preventDefault()
    account = template.data
    tx = processForm event.currentTarget
    tx.type = 'credit'
    tx.amount = tx.amount*100
    Accounts.update account._id, {$inc:{balance: tx.amount}, $push: {transactions: tx}}
    Router.go 'accountDetails', account

Template.withdraw.events
  'submit form': (event, template) ->
    event.preventDefault()
    account = template.data
    tx = processForm event.currentTarget
    tx.type = 'debit'
    tx.amount = tx.amount*-100
    Accounts.update account._id, {$inc:{balance: tx.amount}, $push: {transactions: tx}}
    Router.go 'accountDetails', account

processForm = (target, defaultValue) ->
  form = {}
  array = $(target).serializeArray()
  _.each array, (formItem) ->
    element = $(target).find("input[name='" + formItem.name + "']")
    type = element.attr('type')
    multiple = $(target).find("select[name='" + formItem.name + "']").attr('multiple')
    if element.hasClass('tp-ignore')
      # skip it
    else if formItem.value is 'true' or formItem.value is 'false'
      return form[formItem.name] = formItem.value is 'true'
    else if multiple?
      val = $("select[name='#{formItem.name}']").val()
      return form[formItem.name] = val
    else if formItem.value?.length > 0 and formItem.value isnt "[object Object]"
      return form[formItem.name] = formItem.value
    else if typeof defaultValue == "undefined"
      return form[formItem.name] =  undefined
    else
      return form[formItem.name] =  defaultValue

  return form