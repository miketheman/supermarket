json.cache! @cookbooks do
  @cookbooks.each do |name, cookbook|
    json.set! name do
      cookbook.cookbook_versions.each do |cookbook_version|
        json.set! cookbook_version.version do
          json.partial! 'api/v1/cookbook_versions/dependencies', dependencies: cookbook_version.cookbook_dependencies
          json.partial! 'api/v1/cookbook_versions/platforms', platforms: cookbook_version.supported_platforms
        end
      end
    end
  end
end
