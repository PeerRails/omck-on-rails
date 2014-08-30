directory '/home/prails/git/omck-on-rails'
environment 'production'
daemonize
pidfile '/home/prails/git/omck-on-rails/tmp/pids/puma.pid'
state_path '/home/prails/git/omck-on-rails/tmp/pids/puma.state'
stdout_redirect '/home/prails/git/omck-on-rails/log/stdout', '/home/prails/git/omck-on-rails/log/stderr', true
bind 'tcp://0.0.0.0:3000'
