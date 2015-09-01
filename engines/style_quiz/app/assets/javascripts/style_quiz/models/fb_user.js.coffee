window.StyleQuiz ||= {}
window.StyleQuiz.FbUser = class FbUser
  constructor: (opts = {}) ->
    @initialized = false
    @connected = false
    @granted_permissions = []
    _.delay(@init, 500)

  init: (opts = {}) =>
    if typeof(FB) == 'object'
      @getLoginStatus() unless @initialized
    else
      _.delay(@init, 500)

  getEvents: (callback) ->
    @callFacebookApi('/me/events', ['user_events'], callback)

  getUserProfile: (callback) ->
    @callFacebookApi('/me', ['email','user_birthday'], callback)

  getLoginStatus: () =>
    FB.getLoginStatus( (response) =>
      @initialized = true
      if (response && response.status == 'connected')
        @connected = true
        @loadGivenPermissions()
    )

  loadGivenPermissions: () =>
    FB.api('/me/permissions', (data) =>
      @connected = true
      @granted_permissions = _.chain(data.data).
        where({status: 'granted' }).
        map((i) -> i.permission).
        value()
    )

  callFacebookApi: (endpoint, required_permissions, callback) ->
    missing_permissions = _.without.apply(@,  [required_permissions].concat(@granted_permissions))

    if @connected
      if missing_permissions.length == 0
        # call api
        FB.api(endpoint, callback)
      else
        # re-request missing permissions
        FB.login( (response) =>
          if (response.authResponse && response.status == 'connected')
            @loadGivenPermissions()
            FB.api(endpoint, callback)
        , {
          scope: missing_permissions.join(),
          auth_type: 'rerequest'
        })
    else
      # login with all permissions
      FB.login( (response) =>
        if (response.authResponse && response.status == 'connected')
          @loadGivenPermissions()
          FB.api(endpoint, callback)
      , {
        scope: 'email,user_birthday,user_events,user_friends',
      })
