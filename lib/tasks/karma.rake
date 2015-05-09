namespace :karma do
  task :start => :environment do
    karma_bin = Rails.root.join('./node_modules/karma/bin/karma')
    karma_conf = Rails.root.join('./spec/karma/karma.conf.js')
    exec "#{karma_bin} start #{karma_conf} --single-run"
  end
end