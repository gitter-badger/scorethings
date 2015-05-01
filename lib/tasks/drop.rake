namespace :db do
  desc 'Load the drop data from db/drop.rb'
  task :drop => :environment do
    drop_file = File.join(Rails.root, 'db', 'drop.rb')
    load(drop_file) if File.exist?(drop_file)
  end
end