environment ENV["RAILS_ENV"] || 'development'
pidfile 'log/puma.pid'
state_path 'log/puma.state'
stdout_redirect nil, 'log/stderr.log', true
bind "tcp://0.0.0.0:3000"
daemonize
preload_app!
tag 'omcktv'
