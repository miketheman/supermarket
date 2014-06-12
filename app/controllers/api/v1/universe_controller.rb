class Api::V1::UniverseController < Api::V1Controller
  CACHE_KEY = 'universe'

  #
  # GET /universe
  #
  # Returns a JSON response that should be compatible with the current
  # Berkshelf API response. It will have cookbooks, all their versions, and
  # dependency/platform information.
  #
  def index
    @cookbooks = Rails.cache.fetch(CACHE_KEY, expires_in: 12.hours, race_condition_ttl: 10) do
      Cookbook.includes(cookbook_versions: [:cookbook_dependencies, :supported_platforms]).
        select('id, name').
        index_by(&:name)
    end
  end
end
