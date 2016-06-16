class AppnexusApi::CreativeTemplateService < AppnexusApi::Service
  def name
    "template"
  end

  def resource_class
    AppnexusApi::CreativeTemplateResource
  end

  def uri_suffix
    "template"
  end

  def delete(id)
    raise AppnexusApi::NotImplemented
  end

end
