require 'octokit'

class RepositoryUpdater
  class << self
    def update
      Repository.order('updated_at').limit(10).each do |repo|
        begin
          i = Octokit.repository(repo.name)
          puts "--> #{repo.to_s}"
          repo.update_attributes(forks:       i.forks,
                                 watchers:    i.watchers,
                                 description: i.description,
                                 language:    i.language)
        rescue Octokit::NotFound => e
          # TODO: Maybe have an error_count field, delete repos that fail too many updates
          puts "    #{e}"
        end
      end
    end
  end
end
