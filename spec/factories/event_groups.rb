Factory.define :event_group_1, :class => EventGroup, :singleton => true do |eg|
  eg.id 1
  eg.name "Campus for Christ"
  eg.parent_id nil
  eg.allows_multiple_applications_with_same_form false
end

Factory.define :event_group_2, :class => EventGroup, :singleton => true do |eg|
  eg.id 1
  eg.name "Sub C4C Multiform"
  eg.parent_id nil
  eg.allows_multiple_applications_with_same_form true
end


