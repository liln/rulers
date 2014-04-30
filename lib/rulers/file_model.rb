require "multi_json"

module Rulers
  module Model
    class FileModel
      def initialize(filename)
        @filename = filename

        # if filename is dir/37.json, @id is 37
        basename = File.split(filename)[-1]
        @id = File.basename(basename, ".json").to_i

        obj = File.read(filename)
        @hash = MultiJson.load(obj)
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def self.find(id)
        begin
          # ActiveRecord cache model - my copy, no sharing
          FileModel.new("db/quotes/#{id}.json")

          # DataMapper cache model - "why ever have more than one?"
          # Object.const_get() SOMETHING?!@?
        rescue
          return nil
        end
      end

      def self.all
        files = Dir["db/quotes/*.json"]
        files.map { |f| FileModel.new f }
      end

      def self.find_all_by_submitter(name)
        files = Dir["db/quotes/*.json"]
        filertn = []
        files.each do |file|
          obj = File.read(file)
          hash = MultiJson.load(obj)
          if hash["submitter"] == name
            filertn << FileModel.new(file)
          end
        end
        filertn
      end

      def self.create(attrs)
        hash = {}
        hash["submitter"] = attrs["submitter"] || ""
        hash["quote"] = attrs["quote"] || ""
        hash["attribution"] = attrs["attribution"] || ""

        files = Dir["db/quotes/*.json"]
        names = files.map { |f| f.split("/")[-1] }
        highest = names.map { |b| b.to_i }.max
        id = highest + 1

        File.open("db/quotes/#{id}.json","w") do |f|
          f.write <<TEMPLATE
{
  "submitter": "#{hash["submitter"]}",
  "quote": "#{hash["quote"]}",
  "attribution": "#{hash["attribution"]}"
}
TEMPLATE
        end

        FileModel.new "db/quotes/#{id}.json"
      end

      def save
        File.open(@filename, "w") do |f|
          f.write MultiJson.dump(@hash)
        end
      end
    end
  end
end
