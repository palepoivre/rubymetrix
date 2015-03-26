require 'json' 
require 'google_chart'
require 'rubygems'
require 'open-uri'
require 'zlib'
require 'yajl' 

class WelcomeController < ApplicationController

	def index
		gz = open('http://data.githubarchive.org/2015-01-01-15.json.gz')
		@js = Zlib::GzipReader.new(gz).read
		 
		#Yajl::Parser.parse(js) do |event|
		#print event
		#end 
		#file = File.read('test.json')
#@data_hash = JSON.parse(file)
		#GoogleChart::PieChart.new('320x200', "Things I Like To Eat", false) do |pc| 
		#  pc.data "Broccoli", 30
		#  pc.data "Pizza", 20
		#  pc.data "PB&J", 40 
		#  pc.data "Turnips", 10 
		# @chart = pc
		#end
	end

end
