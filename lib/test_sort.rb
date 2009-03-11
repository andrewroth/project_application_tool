   require 'benchmark'
   require 'bsearch.rb'
   include Benchmark

   a = (1..100000).map {rand(100000)}

   bm(10) do |b|
     b.report("Sort")    { a.sort }
     b.report("Sort by") { a.sort_by {|i| i} }
     b.report("Default seach") {  a.find{ |i| i == 3456 }  }
     b.report("Binary seach") {  a.sort!; a.bsearch_first{ |i| i <=> 3456 }  }
   end
