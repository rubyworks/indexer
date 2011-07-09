When 'Given a `(((.*?)))` file' do |file, text|
  File.open(file, 'w'){ |f| f << text }
end

