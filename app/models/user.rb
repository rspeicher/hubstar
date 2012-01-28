class User < ActiveRecord::Base
  attr_accessible :username, :github_data, :github_access_token

  serialize :github_data

  delegate :login, :avatar_url, :html_url, :to => :github_data

  has_and_belongs_to_many :repositories

  # Convert github_data to a <tt>Hashie::Mash</tt> object so that delegation works
  def github_data
    @github_data ||= Hashie::Mash.new(read_attribute(:github_data))
  end

  def to_s
    username
  end
end
