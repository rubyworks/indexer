# Setup an AE ok-check for testing field assignment.
#
# @todo best match for this?
When '`(((\w+)))` field (((is|holds)))' do |name, _|
  check "#{name} setting invalid" do |value|
    data = Indexer::V0::Metadata.new
    begin
      data.send("#{name}=", value)
      true
    rescue Indexer::ValidationError
      false
    end
  end
end

