namespace :db do
  desc 'Reset data from db/seeds.rb (using db/drop.rb first)'
  task :reset => :environment do
    drop_file = File.join(Rails.root, 'db', 'drop.rb')
    seed_file = File.join(Rails.root, 'db', 'reset.rb')
    if File.exists?(drop_file) && File.exist?(seed_file)
      load(drop_file)
      load(seed_file)
    end
  end
end