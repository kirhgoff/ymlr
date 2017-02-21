require "yaml"

module Ymlr

  class DuplicatesResults
    attr_reader :duplicates, :overrides, :files
    
    def initialize(first_file, second_file)
      @files = [first_file, second_file]
      @duplicates = {} # key => value
      @overrides = {} # key => [first_value, second_value] 
      @missed_first = {}
      @missed_second = {}
    end

    def add_duplicate(key, value)
      @duplicates[key] = value
    end

    def add_override(key, value1, value2)
      @overrides[key] = [value1, value2]
    end

    def add_missed_first(key, value)
      @missed_first[key] = value
    end

    def add_missed_second(hash)
      @missed_second.merge!(hash)
    end
  end

  class DuplicatesFinder 
    def flat_hash(hash, k = "")
      return {k => hash} unless hash.is_a?(Hash)
      hash.inject({}){ |h, v| h.merge! flat_hash(v[-1], "#{k}.#{v[0]}") }
    end

    def load_yaml(file_name) 
      file = YAML.load_file(file_name)
      flat_hash(file)
    end

    def find_duplicates(first_file, second_file)
      first = load_yaml(first_file)
      second = load_yaml(second_file)

      result = DuplicatesResults.new(first_file, second_file) 

      first.each do |key, value|
        if second.has_key?(key) 
          if second[key] == value
            result.add_duplicate(key, value)
          else
            result.add_override(key, value, second[key])
          end
          second.delete(key)
        else
          result.add_missed_first(key, value)
        end
      end
      result.add_missed_second(second)
      result
    end
  end
end

