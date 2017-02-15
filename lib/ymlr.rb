require "ymlr/version"

module Ymlr
  
  def flat_hash(hash, k = [])
      return {k => hash} unless hash.is_a?(Hash)
      hash.inject({}){ |h, v| h.merge! flat_hash(v[-1], k + [v[0]]) }
  end
  
  def load_yaml(file_name) 
      file = YAML.load_file(file_name)
      flat_hash(file)
  end

  def find_duplicates(first_file, second_file) 
    first = load_yaml(first_file)
    second = load_yaml(second_file)

    first.each do |key, value|
      if second.has_key?(key) 
          if second[key] == value
              puts "Duplicate: #{key.join('.')} => #{value}"    
          else
              puts "Overriden: #{key.join('.')} => #{value} vs #{second[key]}"
          end
      end
    end
  end

end

