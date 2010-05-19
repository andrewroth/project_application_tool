Factory.define :appln_1, :class => Appln, :singleton => true do |a|
  a.id 1
  a.form_id 1
  a.viewer_id 1
end

Factory.define :appln_2, :class => Appln, :singleton => true do |a|
  a.id 2
  a.form_id 1
  a.viewer_id 1
end
