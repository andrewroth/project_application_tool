Factory.sequence :title do |n|
  "title_#{n}"
end

Factory.define :page do |p|
  p.title { |t| 
    t = Factory.next(:title)
  }
  p.after_create{ |page|
    Factory(:page_element, :page => page, :element => Factory(:textarea))
  }
end
