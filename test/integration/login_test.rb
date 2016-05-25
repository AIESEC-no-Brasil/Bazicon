class LoginTest < ActionDispatch::IntegrationTest

 test "unsuccessful login" do
    get "/"
    assert_response :success
    post login_path,  :email =>  ENV['EB_USER_MAIL_1'], :password => ENV['EB_USER_WRONG_PASS_1']
    assert_equal "Invalid Username or Password", flash[:notice]
      #test if user after login was redirected to login page after
    assert_redirected_to  index_path
    #test if session was not created
    assert_equal nil, session[:user_id]
  end

  test "successful login" do

    get "/"
    assert_response :success
    post login_path, :email =>  ENV['EB_USER_MAIL_1'], :password => ENV['EB_USER_PASS_1']
    assert_equal nil, flash[:notice]
     #test if user after login was redirected to the welcome path
    assert_redirected_to  main_path
     #test if session was created
    assert_not_equal nil, session


  end

  test "logout" do

    get "/"
    post login_path, ENV['EB_USER_MAIL_1'], :password => ENV['EB_USER_PASS_1']
    get '/logout/'
    assert_equal nil, session[:user_id]

  end


end
