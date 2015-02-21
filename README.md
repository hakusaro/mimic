# mimic
A quick and dirty TShock update server

Mono trusts no CAs by default, meaning that the update manager is completely broken on Mono without installing root certs manually. In order to work around this and to remove human error from the equation, this server just takes the latest github release tag number and pushes it over HTTP.