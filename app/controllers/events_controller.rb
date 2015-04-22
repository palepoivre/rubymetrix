class EventsController < ApplicationController

  # GET /events
  # GET /events.json
  def index

    @events = Event.all
    @labels = []
    @data = []

    @events.each do |event|
      @labels << event.type
      @data << event.nombre
    end

    @msg = ""
    if params['msg'].present?
      @msg = params[:msg]
    end
  end

  # GET /events/new
  def new
   
    time = Time.new #récupère la date actuelle

    month = time.month
    if month < 10 
      month = "0" << time.month.to_s  
    end

    day = time.day
    if day < 10
        day = "0" << time.day.to_s  
    end

    hour = time.hour
    year = time.year
    date = ""
    response = nil

    loop do #recule d'une heure tant que l'on a pas trouvé une archive git
      hour -= 1
      date = year.to_s << "-" <<  month.to_s << "-" << day.to_s << "-" << hour.to_s

      uri = URI("http://data.githubarchive.org/" << date << ".json.gz")
      request = Net::HTTP.new uri.host
      response = request.request_head uri.path

      break if response.code.to_i == 200 || hour == 0 
    end 

    if hour == 0 #si on a pas trouvé d'archive
      redirect_to :controller => 'events', :action => 'index', :msg => "Pas de nouvelle version"

    elsif response.code.to_i == 200 #si on a trouvé une archive

      gz = open("http://data.githubarchive.org/" << date << ".json.gz")
      js = Zlib::GzipReader.new(gz).read

      @events = Hash.new #hash pour stocker les events extrait de l'archive

      Yajl::Parser.parse(js) do |event|

        if @events.has_key?(event['type']) #si l'event est déjà dans la liste
          @events[event['type']] = @events[event['type']] + 1
        else
          @events.store(event['type'], 1)
        end
      end 

      Event.all.destroy
      
      @events.each do |key, value|
        myevent = Event.new
        myevent.type = key
        myevent.nombre = value
        myevent.save
      end 
    end
    redirect_to :controller => 'events', :action => 'index', :msg => date
  end
end