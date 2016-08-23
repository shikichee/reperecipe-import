# encoding: utf-8
require "csv"

unless ARGV.length == 2 then
    puts "ruby createMongoData.rb inputFilePath outputFilePath" 
    exit
end

outputFile = File.open(ARGV[1],'a')
headers, *contents = CSV.read(ARGV[0])
tableName = "ingredients"
outputLine = "db.#{tableName}.insert(["
contents.each do |content|
    outputLine += "{"
    content.each_with_index do |e, j|
      if e.nil? || e.empty? then
        next
      end
      if !(headers[j].nil? || headers[j].empty?) then
        if headers[j] == "readingName" then
          outputLine += "#{headers[j]}:['#{e}'"
          content = content[j+1..-1]
          content.each do |r|
            if r.nil? || r.empty? then
              next
            end
            outputLine += ",'#{r}'"
          end
          outputLine += "]},"
          next
        end
        outputLine += "#{headers[j]}:'#{e}',"
      end
    end
end
outputLine = outputLine.chop + "])"
outputFile.puts(outputLine)
puts outputLine
outputFile.close
