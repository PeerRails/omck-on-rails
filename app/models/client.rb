# == Schema Information
#
# Table name: clients
#
#  id          :integer          not null, primary key
#  name        :string           default("Dwarf")
#  email       :string
#  password    :string
#  admin       :boolean          default(FALSE)
#  streamer    :boolean          default(FALSE)
#  bot         :boolean          default(FALSE)
#  verified    :datetime
#  remember_at :datetime
#  last_login  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Client < ApplicationRecord
	validate :validate_create, on: [:create, :update]

	def validate_create
		errors.add(:email, message: "is already registered") unless Client.find_by_email(self.email).nil?
		errors.add(:name, message: "is blank") if self.name.nil?
	end

	def admin?
		self.admin
	end
	 
	def streamer?
		self.streamer
	end

	def bot?
		self.bot
	end

	def viewer?
		!self.admin? || !self.streamer? || !self.bot?
	end

	def verified?
		self.verified.nil?
	end

	def sessions
		Session.where(client_id: self.id)
				.where("expires > ?", DateTime.now)
	end

end
