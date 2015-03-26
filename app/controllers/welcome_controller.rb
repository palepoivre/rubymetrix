require 'open-uri'
require 'zlib'
require 'yajl' 

class WelcomeController < ApplicationController

	def index
		gz = open('http://data.githubarchive.org/2015-03-26-14.json.gz')
		js = Zlib::GzipReader.new(gz).read
		 
		@cptCreate = 0
		@cptDelete = 0
		@events = []

		Yajl::Parser.parse(js) do |event|
			if event['type'] == "CreateEvent"
				@events << event
				@cptCreate = @cptCreate + 1
			end

			if event['type'] == "DeleteEvent"
				@events << event
				@cptDelete = @cptDelete + 1
			end
		end 

	end

end
