environment ENV["RAILS_ENV"] || 'development'
pidfile '/var/run/puma/puma.pid'
state_path '/var/run/puma/puma.state'
stdout_redirect nil, '/var/log/puma/stderr.log', true
bind "tcp://0.0.0.0:3000"
daemonize
preload_app!
tag 'omcktv'
