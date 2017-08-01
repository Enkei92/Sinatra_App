class User < ActiveRecord::Base
  has_many :task_lists

  def self.from_omniauth(auth)
    user = User.find_by(provider: auth.provider, uid: auth.uid).take
    unless user
      user = User.create(
        provider: auth.provider,
        uid: auth.uid,
        name: auth.info.name)
      user.task_list.create(title: 'TODO list')
    end
    user
  end
end
