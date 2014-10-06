class User < ActiveRecord::Base
  has_many :transactions

  validates :provider, :uid, :name, :username, :url, presence: true

  def self.find_or_create_from_omniauth(auth)
    provider = auth.provider
    uid = auth.uid

    find_by(provider: provider, uid: uid) || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create(
      provider: auth.provider,
      uid: auth.uid,
      name: auth.info.name,
      username: auth.info.nickname,
      url: auth.info.urls["Twitter"],
      image: auth.info.image
    )
  end
end
