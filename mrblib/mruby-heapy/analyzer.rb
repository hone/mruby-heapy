module Heapy
  class Analyzer
    def initialize(filename)
      @filename = filename
    end

    def drill_down(generation)
      puts ""
      puts "Analyzing Heap (Generation: #{generation})"
      puts "-------------------------------"
      puts ""

      generation = generation.to_i

      #
      memsize_hash = Hash.new { |h, k| h[k] = 0 }
      count_hash   = Hash.new { |h, k| h[k] = 0 }
      File.open(@filename) do |f|
        f.each_line do |line|
          begin
            parsed = JSON.parse(line)
            if parsed["generation"] == generation
              key = "#{ parsed["file"] }:#{ parsed["line"] }"
              memsize_hash[key] += parsed["memsize"]
              count_hash[key]   += 1
            end
          rescue JSON::ParserError
            puts "Could not parse #{line}"
          end
        end
      end

      total_memsize = memsize_hash.inject(0) do |count, tuple|
        _, v = tuple
        count += v
      end

      # /Users/richardschneeman/Documents/projects/codetriage/app/views/layouts/application.html.slim:1"=>[{"address"=>"0x7f8a4fbf2328", "type"=>"STRING", "class"=>"0x7f8a4d5dec68", "bytesize"=>223051, "capacity"=>376832, "encoding"=>"UTF-8", "file"=>"/Users/richardschneeman/Documents/projects/codetriage/app/views/layouts/application.html.slim", "line"=>1, "method"=>"new", "generation"=>36, "memsize"=>377065, "flags"=>{"wb_protected"=>true, "old"=>true, "long_lived"=>true, "marked"=>true}}]}
      puts "allocated by memory (#{total_memsize}) (in bytes)"
      puts "=============================="
      memsize_hash = memsize_hash.sort do |tuple1, tuple2|
        _, v1 = tuple1
        _, v2 = tuple2
        v2 <=> v1
      end
      longest      = memsize_hash.first[1].to_s.length
      memsize_hash.each do |file_line, memsize|
        puts "  #{memsize.to_s.rjust(longest)}  #{file_line}"
      end

      total_count = count_hash.inject(0) do |count, tuple|
        _, v = tuple
        count += v
      end

      puts ""
      puts "object count (#{total_count})"
      puts "============"
      count_hash = count_hash.sort do |tuple1, tuple2|
        _, v1 = tuple1
        _, v2 = tuple2
        v2 <=> v1
      end
      longest      = count_hash.first[1].to_s.length
      count_hash.each do |file_line, memsize|
        puts "  #{memsize.to_s.rjust(longest)}  #{file_line}"
      end
    end

    def analyze
      puts ""
      puts "Analyzing Heap"
      puts "=============="

      # generation number is key, value is count
      data = Hash.new {|h, k| h[k] = 0 }

      File.open(@filename) do |f|
        f.each_line do |line|
          begin
            line = line.chomp
            json = JSON.parse(line)
            data[json["generation"]||0] += 1
          rescue JSON::ParserError
            puts "Could not parse #{line}"
          end
        end
      end

      data = data.sort
      max_length = data.last[0].to_s.length
      data.each do |generation, count|
        puts "Generation: #{ generation.to_s.rjust(max_length) } object count: #{ count }"
      end
    end
  end
end
