# Generated by Selenium IDE
require 'selenium-webdriver'
require 'json'
describe 'Createandcheckroom' do
  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @vars = {}
  end
  after(:each) do
    @driver.quit
  end
  it 'createandcheckroom' do
    @driver.get('http://localhost:3000/en')
    @driver.find_element(:link_text, 'Log in').click
    @driver.find_element(:id, 'username').click
    @driver.find_element(:id, 'username').send_keys('admin')
    @driver.find_element(:id, 'password').click
    @driver.find_element(:id, 'password').send_keys('12345678')
    @driver.find_element(:name, 'commit').click
    @driver.find_element(:link_text, 'Check rooms').click
    @driver.find_element(:link_text, 'New room').click
    @driver.find_element(:id, 'room_name').click
    @driver.find_element(:id, 'room_name').send_keys('room1')
    @driver.find_element(:id, 'room_description').click
    @driver.find_element(:id, 'room_description').send_keys('description for room1 and its features')
    @driver.find_element(:id, 'room_images').send_keys("#{Rails.root}/spec/support/assets/images/rooms/0x0.jpg")
    @driver.find_element(:id, 'room_cost_per_night').click
    @driver.find_element(:id, 'room_cost_per_night').send_keys('300')
    @driver.find_element(:css, 'html').click
    @driver.find_element(:name, 'commit').click
    expect(@driver.find_element(:css, '.card-text:nth-child(2)').text).to eq('description for room1 and its features')
    expect(@driver.find_element(:css, 'small').text).to eq('Cost per night:300.0')
    @driver.find_element(:css, '.btn:nth-child(2)').click
    @driver.find_element(:link_text, 'Log out').click
  end
end
