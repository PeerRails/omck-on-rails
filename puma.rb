directory ENV["PUMAPATH"]
environment ENV["RAILS_ENV"] || 'development'
pidfile ENV["PUMAPATH"]+'/pids/puma.pid'
state_path ENV["PUMAPATH"]+'/pids/puma.state'
stdout_redirect nil, ENV["PUMAPATH"]+'/log/stderr.log', true
bind "tcp://0.0.0.0:#{ENV["PUMAPORT"] || 3000}"
daemonize
