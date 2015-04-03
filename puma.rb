environment ENV["RAILS_ENV"] || 'development'
pidfile 'pids/puma.pid'
state_path 'pids/puma.state'
stdout_redirect nil, 'log/stderr.log', true
bind "tcp://0.0.0.0:#{ENV["PUMAPORT"] || 3000}"
daemonize
