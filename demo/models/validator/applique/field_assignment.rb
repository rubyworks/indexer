# Setup an AE ok-check for testing field assignment.
#
# @todo best match for this?
When '`(((\w+)))` field (((is|holds)))' do |name, _|
  check "#{name} setting invalid" do |value|
    data = Indexer::Validator.new
    begin
      data.send("#{name}=", value)
      true
    rescue Indexer::ValidationError
      false
    end
  end
end

