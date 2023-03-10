# Generated by Selenium IDE
require 'selenium-webdriver'
require 'json'
describe 'Registerlogin' do
  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @vars = {}
  end
  after(:each) do
    @driver.quit
  end
  it 'registerlogin' do
    @driver.get('http://localhost:3000/en')
    @driver.find_element(:link_text, 'Register').click
    @driver.find_element(:id, 'user_username').click
    @driver.find_element(:id, 'user_username').send_keys('testuser')
    @driver.find_element(:id, 'user_password').click
    @driver.find_element(:id, 'user_email').click
    @driver.find_element(:id, 'user_email').send_keys('testusermail@gmail.com')
    @driver.find_element(:id, 'user_password').send_keys('testpass')
    @driver.find_element(:name, 'commit').click
    @driver.find_element(:id, 'username').click
    @driver.find_element(:id, 'username').send_keys('testuser')
    @driver.find_element(:id, 'password').click
    @driver.find_element(:id, 'password').send_keys('testpass')
    @driver.find_element(:name, 'commit').click
    @driver.find_element(:link_text, 'User: testuser').click
    expect(@driver.find_element(:css, '#user_4 > p:nth-child(1)').text).to eq('Username: testuser')
    @driver.find_element(:id, 'deleteuser').click
  end
end
