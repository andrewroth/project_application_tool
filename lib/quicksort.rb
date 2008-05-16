# QuickSort (in place)

# accepts an array or a string
# see below for sample call

def partition(list, left, right, pindex)
   pvalue = list [pindex]
   swap(list, pindex, right)
   sindex = left
   for i in left .. right-1
       if (list[i] <=> pvalue) < 0
          swap(list, sindex, i)
          sindex = sindex + 1
       end
   end
   swap(list, right, sindex)
   return sindex
end

def swap (arr, l, r)
  tmp = arr [l]
  arr[l] = arr[r]
  arr[r] = tmp
end

def quicksort(list, left, right)
  if (right > left)
    pIndex = left
    newPindex = partition(list, left, right, pIndex)
    quicksort(list, left, newPindex-1)
    quicksort(list, newPindex+1, right)
  end
end

=begin
str= 'ZZ WW YY VV XX CC DD FF EE AA !@#$%^&'
iarr= [254,23,10,888,12,50,70,13,15,67,99]

puts "str before: "
puts str

quicksort(str,0,str.length-1)

puts "str after: "
puts str

puts "iarr before: "
iarr.each {|ea| print(ea," ")}
puts

quicksort(iarr,0,iarr.length-1)

puts "iarr after: "
iarr.each {|ea| print(ea," ")}
puts
=end
