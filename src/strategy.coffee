CouchLogin   = require "couch-login"
CloudantUser = require "cloudant-user"
errify       = require "errify"


class CouchStrategy
  name: "couch"

  constructor: (options) ->
    @usernameField = options.usernameField or "username"
    @passwordField = options.passwordField or "password"
    @host          = options.host
    {auth}         = options
    @cloudantUser  = new CloudantUser {@host, auth}

  serializeUser: (user, done) ->
    done null, user.name

  deserializeUser: (id, done) ->
    @cloudantUser.get id, done

  authenticate: (req, options) ->
    ideally  = errify @error
    username = req.body[@usernameField]
    password = req.body[@passwordField]
    couch    = new CouchLogin @host

    await couch.login {name: username, password, form: true}, ideally defer res, user
    return @fail "couch login", res.statusCode if res.statusCode >= 400

    @success user


module.exports = CouchStrategy
