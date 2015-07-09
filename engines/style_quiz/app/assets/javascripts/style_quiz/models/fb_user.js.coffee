window.StyleQuiz ||= {}
window.StyleQuiz.FbUser = class FbUser
  constructor: (opts = {}) ->
    # init

  getEvents: (callback) ->
    @callFacebookApi('/me/events', ['user_events'], callback)

  getUserProfile: (callback) ->
    @callFacebookApi('/me', ['email,user_birthday'], callback)

  checkUserGrantedPermissions: (opts = {}) ->
    permissions = opts.permissions
    success_callback = opts.success
    failure_callback = opts.failure

    FB.api('/me/permissions', (data) ->
      granted_permissions = _.chain(data.data).
        where({status: 'granted' }).
        map((i) -> i.permission).
        value()

      missing_permissions = _.without.apply(@,  [permissions[0].split(',')].concat(granted_permissions))
      if missing_permissions.length == 0
        success_callback()
      else
        failure_callback(missing_permissions)
    )

  callFacebookApi: (endpoint, required_permissions, callback) ->
    that = @
    # check permissions & call func
    userLoggedInFunc = () ->
      that.checkUserGrantedPermissions(
        permissions : required_permissions,
        success: () ->
          FB.api(endpoint, callback)
        failure: (missing_permissions) ->
          FB.login( (response) ->
            if (response.authResponse && response.status == 'connected')
              FB.api(endpoint, callback)
          , {
            scope: missing_permissions.join(),
            auth_type: 'rerequest'
          })
      )

    # trying to receive all permissions & call func
    userNotLoggedInFunc = () ->
      FB.login( (response) ->
        if (response.authResponse && response.status == 'connected')
          FB.api(endpoint, callback)
      , scope: 'email,user_birthday,user_events,user_friends'
      )

    FB.getLoginStatus( (response) ->
      if (response && response.status == 'connected')
        userLoggedInFunc()
      else
        userNotLoggedInFunc()
    )
