class AppnexusApi::CategoryService < AppnexusApi::Service

  def initialize(connection)
    @read_only = true
    super(connection)
  end

  def plural_name
    "categories"
  end

end
