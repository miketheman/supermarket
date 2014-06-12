json.set! :platforms do
  platforms.each do |platform|
    json.set! platform.name, platform.version_constraint
  end
end
