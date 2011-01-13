# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :project do |f|
  f.name "My Project"
  f.planned_start_at "2011-01-06 15:42:11"
  f.published_by 1
  f.worker nil
  f.deleted_at "2011-01-06 15:42:11"
end
