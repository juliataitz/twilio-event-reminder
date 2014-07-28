namespace :users do
  task :send_all_messages => :environment do
    User.send_all_messages
  end
end