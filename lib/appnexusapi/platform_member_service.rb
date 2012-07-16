class AppnexusApi::PlatformMemberService < AppnexusApi::Service

  def initialize(connection)
    @read_only = true
    super(connection)
  end

end
