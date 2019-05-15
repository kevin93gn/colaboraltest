# This file is used by Rack-based servers to start the application.


# --- Start of unicorn worker killer code ---

=begin


unicorn-worker-killer kills workers given 2 conditions: Max requests and Max memory.

Max Requests

In this example, a worker is killed if it has handled between 500 to 600 requests. Notice that this is a range.
This minimises the occurrence where more than 1 worker is terminated simultaneously.


Max Memory

Here, a worker is killed if it consumes between 240 to 260 MB of memory. This is a range for the same reason as above.
Every app has unique memory requirements. You should have a rough gauge of the memory consumption of your application during normal operation. That way, you could give a better estimate of the minimum and maximum memory consumption for your workers.

                                                                                                                                                                                                                                                                                                                                                                Once you have configured everything properly, upon deploying your app, you will notice a much lesser erratic memory behaviour:=end
=end

if ENV['RAILS_ENV'] == 'production'
  require 'unicorn/worker_killer'

  max_request_min =  500
  max_request_max =  600

  # Max requests per worker
  use Unicorn::WorkerKiller::MaxRequests, max_request_min, max_request_max

  oom_min = (240) * (1024**2)
  oom_max = (260) * (1024**2)

  # Max memory size (RSS) per worker
  use Unicorn::WorkerKiller::Oom, oom_min, oom_max
end

# --- End of unicorn worker killer code ---

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application

