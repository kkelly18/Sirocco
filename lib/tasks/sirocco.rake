namespace :sirocco do
  desc "Run all tests"
  task :test_prereg => :environment do
    Rake::Task['db:test:prepare'].invoke
    Rake::Task['tmp:clear'].invoke
  end
  
  task :spec => :test_prereq do
    t.spec_files = FileList['spec/**/*_spec.rb']
  end

end
