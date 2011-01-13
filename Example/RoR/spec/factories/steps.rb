# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :milestone do |f|
  f.title "MyString"
  f.completed_at "2011-01-11 22:21:29"
  f.sequence_order 1
  f.project nil
  f.deleted_at "2011-01-11 22:21:29"
end
