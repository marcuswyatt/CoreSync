# Configure generators values. Many other options are available, be sure to check the documentation.
Rails.application.config.generators do |g|
    g.orm             :active_record
    g.template_engine :erubis, :form_builder => :formtastic 
    g.test_framework  :rspec, :fixture => true, :views => false
    g.fallbacks[:rspec] = :test_unit
    g.fixture_replacement :factory_girl, :dir => "spec/factories"
end
