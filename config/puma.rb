threads Integer(8 || 1), Integer(32 || 10)
on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end