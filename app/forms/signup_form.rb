class SignupForm < Reform::Form
  property :nickname#, :password

  validation do
    required(:nickname).filled
  end
end
