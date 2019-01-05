class User < ApplicationRecord
  validates_presence_of :external_key, :name

  def appear
    self.update(online: true)
  end

  def disappear
    self.update(online: false)
  end
end
