namespace :protractor do
  task :run => :environment do
    # FIXME figure out how to run protractor e2e with twitter oauth
    protractor_conf = Rails.root.join('./spec/e2e/protractor.conf.js')
    exec "protractor #{protractor_conf}"
  end
end