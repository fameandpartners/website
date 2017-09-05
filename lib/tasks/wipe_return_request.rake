namespace :data do
  desc 'Wipe out records associated with a order return request'
  task :wipey_return, [:order_number] => [:environment] do [t, args]

  end
end
