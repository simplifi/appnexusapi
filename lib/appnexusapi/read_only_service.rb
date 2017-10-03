module AppnexusApi
  class ReadOnlyService < Service
    def initialize(connection)
      @read_only = true
      super(connection)
    end
  end
end
