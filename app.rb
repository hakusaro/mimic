require 'sinatra'
require 'httparty'

$update_package = nil
$last = nil

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
end

post '/ghwebhook/?' do
  update_version_number
end

get '/latest/?' do
  if $version_number == nil
    update_version_number
  end

  status 200
  content_type 'application/json'
  return JSON.pretty_generate($update_package)
end