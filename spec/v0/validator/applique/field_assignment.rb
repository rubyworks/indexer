# Setup an AE ok-check for testing field assignment.
#
# @todo best match for this?
When '`(((\w+)))` field (((is|holds)))' do |name, _|
  check "#{name} setting invalid" do |value|
    data = DotRuby::Validator.new
    begin
      data.send("#{name}=", value)
      true
    rescue DotRuby::ValidationError
      false
    end
  end
end

