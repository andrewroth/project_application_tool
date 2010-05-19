Factory.define :viewer_1, :class => Viewer, :singleton => true do |u|
  u.id '1'
  u.viewer_userID 'josh.starcher@example.com'
end

Factory.define :viewer_2, :class => Viewer, :singleton => true do |u|
  u.id '2'
  u.viewer_userID 'fred@uscm.org'
end

Factory.define :viewer_3, :class => Viewer, :singleton => true do |u|
  u.id '3'
  u.viewer_userID 'sue@student.org'
  u.guid ''
end

Factory.define :viewer_4, :class => Viewer, :singleton => true do |u|
  u.id '4'
  u.viewer_userID 'viewer_with_no_ministry_involvements'
end

Factory.define :viewer_5, :class => Viewer, :singleton => true do |u|
  u.id '5'
  u.viewer_userID 'min_leader_with_no_permanent_address'
end

Factory.define :viewer_6, :class => Viewer, :singleton => true do |u|
  u.id '6'
  u.viewer_userID 'staff_on_ministry_with_no_campus'
  u.guid '253b648c-3537-464c-b97a-e2d7e2c748b9'
end
