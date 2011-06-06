# Setup an AE ok-check for testing field assignment.
#
# @todo best match for this?
When '`(((\w+)))` field is' do |name|
  check "#{name} setting invalid" do |value|
    data = DotRuby::Data.new
    begin
      data.send("#{name}=", value)
      true
    rescue DotRuby::InvalidMetadata
      false
    end
  end
end

