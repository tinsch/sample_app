require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
  	@user = User.new(name: "Example User", email: "user@example.com",
                      password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
  	assert @user.valid?  	
  end

  test "name should be present" do
  	@user.name = "      "
  	assert_not @user.valid?
  end

  test "email should be present" do
  	@user.email = "     "
  	assert_not @user.valid?
  end

  test "name should not be too long" do
  	@user.name = "a" * 51
  	assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 256
    assert_not @user.valid?
  end

  test "email validation should accept valid adresses" do
    valid_adresses = %w[user@example.com USER@foo.COM A_USE-ER@foo.bar.org
                        first.last@foo.jp alice+bob@baz.cn]
    valid_adresses.each do |valid_adress|
      @user.email = valid_adress
      assert @user.valid?, "#{valid_adress.inspect} should be valid"
    end
  end

  test "email validation should reject invalid adresses" do
    invalid_adresses = %w[user@example,com user_at_foo.org user.name@example. 
                          foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_adresses.each do |invalid_adress|
      @user.email = invalid_adress
      assert_not @user.valid?, "#{invalid_adress.inspect} should be invalid"
    end
  end

  test "email adresses should be unique" do
    dublicate_user = @user.dup
    dublicate_user.email = @user.email.upcase
    @user.save
    assert_not dublicate_user.valid?
  end
  
  test "email adresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" *5
    assert_not @user.valid?
  end
end
