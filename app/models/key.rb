# == Schema Information
#
# Table name: keys
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  key        :string           not null
#  game       :string           default("Boku no Pico"), not null
#  expires    :datetime         default(Thu, 01 Jan 2099 00:00:00 UTC +00:00), not null
#  streamer   :string           default("McDwarf")
#  created_at :datetime
#  updated_at :datetime
#  guest      :boolean          default(FALSE)
#  movie      :string           default("Boku Wa Tomodachi Ga Sekai")
#  created_by :integer
#  client_id  :integer
#




class Key < ApplicationRecord
  belongs_to :client
  has_many :videos
  has_many :streams

  validates :expires, :streamer, :presence => true
  validates :client_id, :presence => true, on: :create
  validates :key, uniqueness: true
  validates :client_id, uniqueness: true, on: :create

  validates_length_of :streamer, in: 3..40
  validates_length_of :game, in: 3..40
  validates_length_of :movie, in: 3..40

  #scope :present, -> { where("expires > ?", DateTime.now).first }

  before_create :generate_key, :make_created_by

  # Generate key secret on key creation
  def generate_key
    self.key = SecureRandom.uuid
  end

  # Set who created key
  def make_created_by
    self.created_by = self.client_id if self.created_by.nil?
  end

  # Change key secret
  # Return [Key]
  def regenerate!
    self.expires = DateTime.now
    generate_key
    save!
  end

end
