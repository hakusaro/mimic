require 'rubygems'
require 'sinatra'
require 'sinatra/base'
require 'httparty'
require './mimic'

use Mimic # Then, it will get to Sinatra.
run lambda {|env| [404, {}, []]} # Bottom of the stack, give 404.
