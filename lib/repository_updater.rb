require 'octokit'

class RepositoryUpdater
  class << self
    def update
      Repository.order('updated_at ASC').limit(15).each do |repo|
        begin
          i = Octokit.repository(repo.name)
          puts "--> #{repo.to_s}"

          # Manually setting updated_at so that even if none of the other
          # attributes have changed, we won't crawl this repo again immediately
          repo.update_attributes({
            forks:       i.forks,
            watchers:    i.watchers,
            description: i.description,
            language:    i.language,
            updated_at:  Time.now
          }, without_protection: true)

        rescue Octokit::NotFound => e
          # TODO: Maybe have an error_count field, delete repos that fail too many updates
          puts "    #{e}"
        end
      end
    end
  end
end
