directory '/home/prails/git/omckonrails'
environment 'development'
daemonize
pidfile '/home/prails/git/omckonrails/tmp/pids/puma.pid'
state_path '/home/prails/git/omckonrails/tmp/pids/puma.state'
stdout_redirect '/home/prails/git/omckonrails/log/stdout', '/home/prails/git/omckonrails/log/stderr', true
bind 'tcp://0.0.0.0:3000'
