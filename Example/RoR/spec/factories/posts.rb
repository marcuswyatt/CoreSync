# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :comment do |f|
  f.title "MyString"
  f.body "MyText"
  f.read_count 1
  f.lat 1.5
  f.lng "9.99"
  f.published_at "2011-01-12 16:27:47"
  f.last_read "2011-01-12 16:27:47"
  f.actioned_at "2011-01-12"
  f.photo ""
  f.published false
end
