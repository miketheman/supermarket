json.set! :dependencies do
  dependencies.each do |dependency|
    json.set! dependency.name, dependency.version_constraint
  end
end
