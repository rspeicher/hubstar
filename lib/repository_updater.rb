require 'octokit'

class RepositoryUpdater
  class << self
    # Public: Fetch initial data for a repository
    def bootstrap
      Repository.where(watchers: nil, forks: nil).each do |repo|
        puts "--> #{repo.to_s}"
        fetch(repo)
      end
    end

    # Public: Update least recently updated repositories.
    #
    # limit - The number of repositories to update
    def update(limit = 15)
      Repository.order('updated_at ASC').limit(limit).each do |repo|
        puts "--> #{repo.to_s}"
        fetch(repo)
      end
    end

    private

    # Private: Fetch the latest info for a repository from GitHub
    #
    # repo - The Repository record to update
    def fetch(repo)
      begin
        repo.touch

        i = Octokit.repository(repo.name)
        repo.update_attributes({
          forks:       i.forks,
          watchers:    i.watchers,
          description: i.description,
          language:    i.language
        })

      rescue Octokit::NotFound => e
        # TODO: Maybe have an error_count field, delete repos that fail too many updates
        puts "    #{e}"
      end
    end
  end
end
