class Repository < ActiveRecord::Base
  attr_accessible :name, :description, :watchers, :forks, :user

  validates :name, uniqueness: true, format: /^[^\/]+\/[^\/]+$/

  has_and_belongs_to_many :users, uniq: true

  def to_s
    name
  end

  # Override as_json so that we can insert some attributes into the resulting
  # object
  #
  # Inserts the number of users that have starred this Repository in the
  # <tt>stars</tt> attribute, and, if given a <tt>:user</tt> argument, checks
  # if the given user has starred this repository in the <tt>hubstarred</tt>
  # attribute.
  def as_json(*args)
    u = args.first.delete(:user)
    hash = super(*args)
    hash.merge!({hubstarred: has_user?(u), stars: users.count})
  end

  # Checks if the given user is present in the record's <tt>users</tt> array.
  def has_user?(user)
    if user.nil?
      false
    else
      self.users.where(id: user.id).count == 1
    end
  end

  # Allows mass-assignment to add a single user to the collection
  def user=(value)
    users << value
  end

  def stars
    users.size
  end
end
