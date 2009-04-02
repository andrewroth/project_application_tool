  
class String
  def last_char
    s = to_s
    s[s.length-1, s.length]
  end
end

#class Array
#  def &(other)
#    union = []
#    inter = []
#    diff = []
#    count = {}
#    (self+other).each {|x| count[x] = 1 + count.fetch(x) {0}}
#    count.each_key {|x|
#            union << x
#            (count[x] > 1 ? inter : diff) << x
#    }
#    inter
#  end
#end
