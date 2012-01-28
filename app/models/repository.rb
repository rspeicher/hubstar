class Repository < ActiveRecord::Base
  attr_accessible :name, :description, :watchers, :forks

  validates :name, :uniqueness => true

  has_and_belongs_to_many :users

  def to_s
    name
  end

  def as_json(*args)
    u = args.first.delete(:user)
    hash = super(*args)
    hash.merge!({:hubstarred => has_user?(u)})
  end

  def has_user?(user)
    if user.nil?
      false
    else
      !(self.users.find(user.id).nil?)
    end
  end
end
