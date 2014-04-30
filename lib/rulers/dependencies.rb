class Object
  def self.const_missing(c)
    return nil if @calling_const_missing

    class_name = c
    @calling_const_missing = true
    require Rulers.to_underscore(c.to_s)
    klass = Object.const_get(c)

    if klass.name.to_s == class_name.to_s
      puts "loaded correct class"
    else
      puts "didn't find it :("
    end
    @calling_const_missing = false

    klass
  end
end
