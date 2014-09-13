directory ENV["PUMAPATH"]
environment ENV["RAILS_ENV"] || 'development'
daemonize
pidfile ENV["PUMAPATH"]+'/pids/puma.pid'
state_path ENV["PUMAPATH"]+'/pids/puma.state'
stdout_redirect ENV["PUMAPATH"]+'/log/stdout.log', ENV["PUMAPATH"]+'/log/stderr.log', true
bind 'tcp://0.0.0.0:3000'
