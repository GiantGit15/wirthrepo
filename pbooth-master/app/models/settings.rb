# This class is tightly coupled with Formotion.
# Formotion persists data using bubble wrap and prepends each field with
# FORMOTION_    see method 'fetch'
# The setting class simply gives up each access to these fields with
# defaults set

class Settings

  class << self

    def server_url
      fetch("server", "http://localhost:3000").to_s
    end

    def password
      fetch("password", nil)
    end

    def remote_branding?
      !!fetch("remote_branding", false)
    end

    def fetch(key, backup)
      settings = App::Persistence['FORMOTION_app_settings']
      settings && settings[key] ? settings[key] : backup
    end
  end
end

