class AppnexusApi::Resource

  attr_reader :dbg_info

  def initialize(json, service, dbg_info = nil)
    @json = json
    @service = service
    @dbg_info = dbg_info
  end

  def update(attributes={})
    resource = @service.update(id, attributes)
    @json = resource.raw_json
  end

  def delete
    @service.delete(id)
  end

  def raw_json
    @json
  end

  def method_missing(sym, *args, &block)
    if @json.respond_to?(sym)
      @json.send(sym, *args, &block)
    elsif @json.has_key?(sym.to_s)
      return @json[sym.to_s]
    else
      super(sym, *args, &block)
    end
  end

  def to_s
    @json.inspect
  end

end
