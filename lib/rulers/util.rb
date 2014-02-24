module Rulers
  def self.to_underscore(string)
    string.gsub(/::/,'/').
    # AAABb -> AAA_Bb
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    # aB -> a_B or 3B -> 3_B
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-","_").
    downcase
  end
end
