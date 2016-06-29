class AppnexusApi::OperatingSystemExtendedService < AppnexusApi::Service
  def initialize(connection)
    @read_only = true
    super(connection)
  end

  def plural_name
    'operating-systems-extended'
  end
end
