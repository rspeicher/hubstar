namespace :repos do
  desc "Update repositories with live info from GitHub"
  task :update => [:environment] do
    require 'repository_updater'
    RepositoryUpdater.update
  end
end
