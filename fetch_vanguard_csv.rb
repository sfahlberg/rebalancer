require 'rubygems'
require 'selenium-webdriver'
require 'uuid'
require 'fileutils'

class FetchVanguardCSV

  WAIT = Selenium::WebDriver::Wait.new(:timeout => 10)

  def self.setup_selenium_browser
    @download_dir = File.join(Dir.pwd, 'data')
    FileUtils.mkdir_p @download_dir

    if File.file?(@download_dir + '/ofxdownload.csv')
      FileUtils.mv(@download_dir + '/ofxdownload.csv', @download_dir + '/archive/' + Time.new().to_i.to_s, verbose: false)
    end

    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['browser.download.dir'] = @download_dir
    profile['browser.download.folderList'] = 2
    profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/pro_eng, text/csv, application/csv, application/vnd.ms-excel, application/x-ofx, application/xml, text/plain'
    @browser = Selenium::WebDriver.for :firefox, profile: profile

    @browser.get 'https://investor.vanguard.com/my-account/log-on'
  end

  def self.get_user_credentials
    user_data = File.read('user_data/user_data.json')
    JSON.parse(user_data)['credentials']
  end

  def self.fill_out_login_page!(credentials)
    input_username = wait_for_el("USER")
    input_username.send_keys(credentials["username"])
    password_field = wait_for_el('PASSWORD')
    password_field.send_keys(credentials["password"])
    button = wait_for_el('login')
    button.click
  end

  def self.fill_out_challenge_page!(credentials)
    challenge_question = wait_for_el('LoginForm:summaryTable')
    challenge_question = challenge_question.find_element(css: 'tbody tr:nth-of-type(2) td:nth-of-type(2)')

    current_answer = nil

    credentials["security_questions"].keys.each do |question|
      if question == challenge_question.text
        current_answer = credentials["security_questions"][question]
      end
    end

    input_challenge = wait_for_el('LoginForm:ANSWER')
    input_challenge.send_keys(current_answer)

    public_computer = wait_for_el('LoginForm:DEVICE:1')
    public_computer.click

    button = wait_for_el('LoginForm:ContinueInput')
    button.click
  end

  def self.download_csv!
    @browser.get 'https://personal.vanguard.com/us/OfxWelcome'

    wait_for_el('vg0')

    dropdown_list = wait_for_el('OfxDownloadForm:downloadOption_main')
    dropdown_list.click

    csv_select = wait_for_el('OfxDownloadForm:downloadOption:_id75')
    csv_select.click

    # check desired accounts
    check = wait_for_el('OfxDownloadForm:selectOrDeselect')
    check.click

    download = wait_for_el('OfxDownloadForm:downloadButtonInput')
    download.click

    p 'download successful'
  end

  def self.end_selenium_browser!
    @browser.quit
  end

  def self.call!
    credentials = get_user_credentials
    setup_selenium_browser
    fill_out_login_page!(credentials)
    fill_out_challenge_page!(credentials)
    download_csv!
    end_selenium_browser!
  end

  def self.wait_for_el(id_name)
    begin 
      WAIT.until do
        element = @browser.find_element(:id, id_name)
        if element.displayed?
          element
        end
      end
    rescue
      puts 'id name: ' + id_name + ' not found on page'
      end_selenium_browser!
      exit
    end
  end
end
