local app    = require('luvit-app'):new()
local json   = require 'json'
local eauth  = require 'luvit-everyauth'
local string = require 'string'

local headers   = {['Content-type'] = 'application/json;charset=utf-8'}
local stringify = json.stringify

json = nil

-- static files
app:mount('/', 'static', {mount = '', root = __dirname .. '/img'})
app:use('render', {prefix = __dirname .. '/views', suffix = '.html'})
app:use(eauth.facebook:middleware({
    app_id     = "181514035247916", 
    app_secret = "8a50402a694ee6a4845bea10a7a5c6aa",
    scope      = "email,user_about_me,user_birthday", 
    fields     = "id,birthday,name,gender,email",
    handle_auth_callback_error = function(self, data) 
      self.res:send(200, stringify(data), headers, true)
    end,
    find_or_create_user = function(self, data, user_data, err)
      self.res:send(200, stringify({data = data, user = user_data}), headers, true)
    end
  }))

app:use(eauth.google:middleware({
    app_id     = "406167907610.apps.googleusercontent.com",
    app_secret = "s9lyi-ob6gEduTQvR3395vuJ",
    scope      = "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email",
    --fields     = "",
    handle_auth_callback_error = function(self, data)
      self.res:send(200, stringify(data), headers, true)
    end,
    find_or_create_user = function(self, data, user_data, err)
      self.res:send(200, stringify({data = data, user = user_data}), headers, true)
    end
  }))

app:GET('/?$', function(self, nxt)
    self:render('index', {title='foo test'})
  end)

app:run(8282, '127.0.0.1')