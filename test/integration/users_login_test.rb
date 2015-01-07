require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = users(:michael)
  end
  
  test 'login and show flash once' do
    get login_path # visit the login path
    assert_template 'sessions/new' # Verify that the new session form renders properly
    post login_path, session: { email: "", password: "" } # post an invalid login
    assert_template 'sessions/new' # see that sessions new page is rendered
    assert_not flash.empty? # chek that page has flash messages
    get root_path # visit a different page like the home page
    assert flash.empty? # verify that the flash message doesn't appear
  end
  
  test "login with valid information followed by logout" do
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    # verifies login link goes away by saying zero login path links on the page
    assert_select "a[href=?]", login_path, count: 0  
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,         count: 0
    assert_select "a[href=?]", user_path(@user),    count: 0
    
  end
  
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end
  
end
