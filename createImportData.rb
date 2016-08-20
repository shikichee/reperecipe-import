# encoding: utf-8
require "csv"

unless ARGV.length == 2 then
    puts "ruby createImportData.rb inputFilePath outputFilePath" 
    exit
end

outputFile = File.open(ARGV[1],'a')
headers, *contents = CSV.read(ARGV[0])
contents.each do |content|
  content.each_with_index do |line, i|
    outputLine = "{"
    content.each_with_index do |e, j|
      if e.nil? || e.empty? then
        next
      end
      if !(headers[j].nil? || headers[j].empty?) then
        if headers[j] == "readingName" then
          outputLine += "\"#{headers[j]}\":{\"l\":[{\"s\":\"#{e}\"}"
          content = content[j+1..-1]
          content.each do |r|
            if r.nil? || r.empty? then
              next
            end
            outputLine += ",{\"s\":\"#{r}\"}"
          end
          outputLine += "]}"
          outputFile.puts(outputLine)
          next
        end
        outputLine += "\"#{headers[j]}\":{\"s\":\"#{e}\"},"
      end
    end
  end
end

outputFile.close
