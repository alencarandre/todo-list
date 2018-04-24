MessageBus.configure(backend: :memory)

MessageBus.configure(group_ids_lookup: proc do |env|
  req = Rack::Request.new(env)
  if req.session && req.session["warden.user.user.key"] && req.session["warden.user.user.key"][0][0]
    user = User.find(req.session["warden.user.user.key"][0][0])
    user.favorites.pluck(:id)
  end
end)
