require 'repository_updater'

namespace :repos do
  desc "Pull initial repository data from GitHub"
  task :bootstrap => [:environment] do
    RepositoryUpdater.bootstrap
  end

  desc "Update repositories with live info from GitHub"
  task :update, [:limit] => [:environment] do |t, args|
    RepositoryUpdater.update(args[:limit] || 15)
  end
end
