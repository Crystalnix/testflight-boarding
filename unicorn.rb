@dir = '.'

worker_processes 2
working_directory @dir

listen 3000, :tcp_nopush => true

# Set process id path
pid "#{@dir}/tmp/unicorn.pid"

stderr_path "#{@dir}/log/unicorn.stderr.log"
stdout_path "#{@dir}/log/unicorn.stdout.log"
