require 'sinatra/base'
require 'httparty'

class Mimic < Sinatra::Base
  $update_package = nil
  $last = nil

  set :environment, :production
  set :port, ARGV[0]

  post '/ghwebhook/?' do
    if update_version_number
      status 202
      return "Ok."
    else
      status 200
      return "Timeout not yet exceeded."
    end
  end

  get '/latest/?' do
    if $update_package == nil
      update_version_number
    end

    status 200
    content_type 'application/json'
    return JSON.pretty_generate($update_package)
  end

  not_found do
    status 404
    return "Not found."
  end

  def update_version_number
    if $last == nil
      $last = Time.now
    else
      unless Time.now > ($last + 300)
        return
      end
    end

    release = HTTParty.get('https://api.github.com/repos/NyxStudios/TShock/releases/latest')

    $update_package = Hash.new
    $update_package['version'] = release['tag_name'].delete('v')
    $update_package['changes'] = release['name']
    return true
  end
end
