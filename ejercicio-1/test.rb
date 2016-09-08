# This class is used for logins
class Login
  attr_reader :sessions, :users, :passwords

  # Receives a hash with usernames as keys and passwords as values
  def initialize(hash)
    @sessions = []
    @users = []
    @passwords = []
    hash.map do |k, v|
      # We must not check if the user k is in users before adding a new one, because keys are unique in a hash
      @users = @users + [k]
      @passwords = @passwords + [v]
    end
  end

  def logout(user)
    sessions.each_with_index do |session, i|
      sessions[i] = nil if session == user
    end
    sessions.compact!
  end

  # Checks if user exists
  def user_exists(user)
    if user == ''
      return false
    end
    for i in users
      if i == user
        return true # we return at the time of checks that user exists
      end
    end
    return false
  end

  # Register user
  def register_user(user, password)
    # We check if the user exists and if the user is not empty
    unless user_exists(user) || user == ''
      last_index = users.size
      users[last_index] = user
      passwords[last_index] = password
    end
  end

  def remove_user(user)
    index = idx(user, users) # We must check if user is already registered.
    unless index == -1
      users[index] = nil
      passwords[index] = nil
      users.compact!
      passwords.compact!
    end
  end

  def check_password(user, password)
    index = idx(user, users)
    if index != -1
      password_correct = passwords[index] == password
      return password_correct
    else
      return false
    end
  end

  def update_password(user, old_password, new_password)
    # First we check if the user exists, we use our user_exists function in order to keep consistence with the way of prove that a user already exists
    if user_exists(user)
      index = idx(user, users)   # there is no need to check if index == -1
      if passwords[index] == old_password
        passwords[index] = new_password
        return true
      end
    end
    return false
  end

  def login(user, password)
    index = idx(user, users)
    if index != -1 && passwords[index] == password # We must check if user exists previously
      sessions << user
    end
  end

  # Gets index of an element in an array, returns -1 in case it doesn't exists
  def idx(element, array)
    cont=0
    for i in array
      return cont if i == element
      cont += 1
    end
    if cont == array.size
      cont=-1
    end
    return cont
  end
end


registered_users = {
    'user1' => 'pass1',
    'user2' => 'pass2',
    'user3' => 'pass3'
}

login = Login.new(registered_users)
puts("Registered Users: #{login.users}")
puts("Registered Passwords: #{login.passwords}")
puts("User -user1- exists? #{login.user_exists('user1')}")
puts("User -user7- exists? #{login.user_exists('user7')}")
puts("Register -user9- pass: -pass9- #{login.register_user('user9', 'pass9')}")
puts("LOGIN: #{login.inspect}")
puts("User -user9- exists? #{login.user_exists('user9')}")
puts("Change Password -user9- to -pass1000- #{login.update_password('user9', 'pass9', 'pass1000')}")
puts("LOGIN: #{login.inspect}")
puts("Login -user9- #{login.login('user9', 'pass1000')}")
puts("LOGIN: #{login.inspect}")
puts("Logout -user9- #{login.logout('user9')}")
puts("LOGIN: #{login.inspect}")
puts("Check password -user9- correct #{login.check_password('user9', 'pass1000')}")
puts("Check password -user9- incorrect #{login.check_password('user9', 'pass9')}")
puts("Remove User -user9- #{login.remove_user('user9')}")
puts("LOGIN: #{login.inspect}")
