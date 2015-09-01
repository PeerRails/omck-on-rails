tag 'omcktv'
environment ENV["RAILS_ENV"] || 'development'

env_workers = ENV["RAILS_ENV"] == "production" ? 2 : 1

workers env_workers
threads 1, 6

app_dir = File.expand_path("../..", __FILE__)
pid_dir = "#{app_dir}/pids"
pidfile "#{pid_dir}/puma.pid"
state_path "#{pid_dir}/puma.state"

stdout_redirect nil, "#{app_dir}/log/stderr.log", true

bind "tcp://0.0.0.0:3000"

daemonize
#preload_app!
