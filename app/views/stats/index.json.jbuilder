json.array!(@stats) do |stat|
  json.extract! stat, :id, :name, :content
  json.url stat_url(stat, format: :json)
end
