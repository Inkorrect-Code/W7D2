# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

# + F => ::find_by_credentials(username, password) as self method
# + I => #is_password?(password)
# + G => #generate_session_token
# + V => #validations
# + A => #attr_reader :password
# + P => #password=(password)
# + E => #ensure_session_token
# + B => #before_validation (ensure_session_token)
# + R => #reset_session_token!
class User < ApplicationRecord
    before_validation :ensure_session_token
    validates :username, uniqueness: true, presence: true
    validates :session_token, uniqueness: true, presence: true
    validates :password_digest, presence: true
    validates :password, allow_nil: true 

    attr_reader :password # can go anywhere

    def self.find_by_credentials(username, password)

        user = User.find_by(username: username)

        if user && user.is_password?(password) # User#is_password?
            user
        else
            nil
        end
    end

    def is_password?(password) # this 'is_password?' is being defined as a method for the user class
        pass = BCrypt::Password.new(self.password_digest)
        pass.is_password?(password) # this 'is_password?' is inherent to the BCrypt, therefore different

    end

    # not necessary to generate session_token here, it is already done by ensure session token (see bluebird) below

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def ensure_session_token
        self.session_token ||= SecureRandom::urlsafe_base64
    end

    def reset_session_token!
        self.session_token = SecureRandom::urlsafe_base64
        self.save!
        self.session_token
    end

    # the code below would be used to store 'SecureRandom...' in 'generate...' to be used in the above methods

    # private 

    # def generate_unique_session_token
    #     session_token = SecureRandom::urlsafe_base64
    # end

end


