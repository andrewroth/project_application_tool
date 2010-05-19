Factory.sequence :title do |n|
  "title_#{n}"
end

Factory.sequence :text do |n|
  "text_#{n}"
end

Factory.define :element do |p|
  p.text { |t| t = Factory.next(:text) }
end

Factory.define :textfield, :class => Textfield, :parent => :element do |p|
end

Factory.define :textarea, :class => Textarea, :parent => :element do |p|
end
