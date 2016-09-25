require 'rails_helper'

describe ApplicationPolicy do
  subject { ApplicationPolicy }

  it "should raise an exception when users aren't logged in" do
    expect{ subject.new(nil, User.new) }.to  raise_error(Pundit::NotAuthorizedError)
  end

end