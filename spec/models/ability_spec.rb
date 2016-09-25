require 'rails_helper'

RSpec.describe Ability do
  let(:user) {build(:user, :admin)}
  subject(:ability){ Ability.new(user) }

  it{ should be_able_to(:manage, :all) }
end
