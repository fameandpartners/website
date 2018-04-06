workers 4
threads 1, 1
queue_requests false
preload_app!
on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end