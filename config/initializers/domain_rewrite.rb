Rails.application.config.middleware.insert_before(Rack::Lock, Rack::Rewrite) do
  r301 %r{.*}, 'http://hubstar.me$&', :if => Proc.new {|rack_env|
    rack_env['SERVER_NAME'] == 'hubstar.herokuapp.com' ||
    rack_env['SERVER_NAME'] == 'www.hubstar.me'
  }
end
