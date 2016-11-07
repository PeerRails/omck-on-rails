# == Schema Information
#
# Table name: channels
#
#  id         :integer          not null, primary key
#  channel    :string
#  live       :boolean          default(FALSE)
#  viewers    :integer          default(0), not null
#  game       :string           default("Boku no Pico"), not null
#  streamer   :string           default("McDwarf")
#  title      :string           default("Boku wa Tomodachi ga Sekai")
#  service    :string           default("twitch")
#  created_at :datetime
#  updated_at :datetime
#  official   :boolean          default(FALSE)
#

class Channel < ApplicationRecord
    has_many :streams

    validates :channel, presence: true
    validates :streamer, presence: true
    validates_format_of :channel, :with => /\A^[a-zA-Z0-9_]{4,25}$\z/i,
                                  :message => "invalid format"
    validates_uniqueness_of :channel, scope: :service

    scope :live, -> { where(live: 'true') }
    scope :official, -> { where(official: true)}
    scope :twitch, -> { where(service: 'twitch') }
    scope :hitbox, -> { where(service: 'hitbox') }
    scope :hd, -> { where(service: 'hd')}

end
