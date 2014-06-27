class ShipList
  def initialize(params={})
    @timestamp = params[:timestamp].try(:to_time)
    @issues    = params[:issues] || []
  end

  attr_reader :timestamp, :issues

  def to_s
    timestamp.strftime("%A, %B %e %Y at %H:%M %Z")
  end

  def to_param
    timestamp.iso8601
  end
end
