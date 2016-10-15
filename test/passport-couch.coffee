{expect}      = require "chai"
errify        = require "errify"
Couch         = require "couch"
CloudantUser  = require "cloudant-user"
CouchStrategy = require "../src/passport-couch"


describe "CouchStrategy", ->
  host     = "http://localhost:5984"
  username = "test"
  password = "user"

  before (done) ->
    couch = Couch "#{host}/_users"
    _id   = "org.couchdb.user:#{username}"
    type  = "user"
    name  = username
    roles = []
    couch.post {_id, type, name, roles, password}, done

  after (done) ->
    couch = Couch "#{host}/_users"
    _id   = "org.couchdb.user:#{username}"
    couch.delete _id, done

  strategy = null
  auth     = {username, password}
  options  = {host, auth}

  beforeEach ->
    strategy = new CouchStrategy options

  afterEach ->
    strategy = null

  describe "##constructor", ->
    it "should initialize default username and password", ->
      expect(strategy.usernameField).to.equal "username"
      expect(strategy.passwordField).to.equal "password"

    it "should set all options from options", ->
      usernameField = "netflix"
      passwordField = "chill"
      _host         = "remote"
      _options      = {usernameField, passwordField, host: _host, auth}

      strategy = new CouchStrategy _options

      expect(strategy[key]).to.equal value for key, value of _options when key isnt "auth"

    it "should create an instance of CloudantUser", ->
      expect(strategy.cloudantUser).to.be.an.instanceof CloudantUser

  describe "##serializeUser", ->
    it "should callback with the username", (done) ->
      ideally = errify done

      await strategy.serializeUser {name: username}, ideally defer name

      expect(name).to.equal username
      done()

  describe "##deserializeUser", ->
    it "should get the user from cloudantUser", (done) ->
      _username = "test"
      await
        strategy.cloudantUser.get = (_id, done) -> done _id
        strategy.deserializeUser _username, defer id

      expect(id).to.equal _username
      done()

  describe "##authenticate", ->
    it "should login the user", (done) ->
      req = body: {username, password}

      await
        strategy.success = defer user
        strategy.authenticate req

      expect(user).to.not.be.empty
      done()

    it "should error if login receives an error", (done) ->
      req           =  body: {}
      strategy.host = "remote"

      await
        strategy.error = defer err
        strategy.authenticate req

      expect(err).to.be.an.instanceof Error
      done()

    it "should fail if it receives a statusCode above 400", (done) ->
      req = body: username: "couch", password: "pillows"

      await
        strategy.fail = defer message, statusCode
        strategy.authenticate req

      expect(message).to.equal "couch login"
      expect(statusCode).to.equal 401
      done()



