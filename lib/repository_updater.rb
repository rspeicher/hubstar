require 'octokit'

class RepositoryUpdater
  class << self
    def update
      Repository.order('updated_at').limit(10).each do |repo|
        begin
          i = Octokit.repository(repo.name)
          repo.update_attributes(forks: i.forks, watchers: i.watchers, description: i.description)
        rescue Octokit::NotFound => e
          # TODO: Maybe have an error_count field, delete repos that fail too many updates
          puts "Could not update #{repo}: #{e}"
        end
      end
    end
  end
end
