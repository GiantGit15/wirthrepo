namespace :foreman do
  # task :restart do
  #   sudo "launchctl unload -wF #{launchd_conf_path}/ledger-web-1.plist; true"
  #   sudo "foreman export launchd #{launchd_conf_path} -d #{release_path} -l /var/log/#{application} -a #{application} -u #{user} -p #{base_port} -c #{concurrency}"
  #   sudo "launchctl load -wF #{launchd_conf_path}/ledger-web-1.plist; true"
  # end

    launchd_conf_path = "/Users/vaughan/Library/LaunchAgents"
    release_path = "/Users/vaughan/projects/pbooth"
    application = "pbooth"
    user = "vaughan"
    base_port = 3000
    concurrency = 1
  
    task :export do
    system "sudo bundle exec foreman export launchd #{launchd_conf_path} -d #{release_path} -l /var/log/#{application} -a #{application} -u #{user} -p #{base_port} -c #{concurrency}" or raise "sum gun wong"
  end

  task :load do
    system "launchctl load -wF #{launchd_conf_path}/vaughan-web-1.plist; true" or raise "sum gun wong"
  end

end
