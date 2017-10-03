class AppnexusApi::ObjectLimitService < AppnexusApi::Service
  def creative_limits
    get(object_type: 'creative').first
  end

  def profile_limits
    get(object_type: 'profile').first
  end

  def domain_list_limits
    get(object_type: 'domain_list').first
  end
end
