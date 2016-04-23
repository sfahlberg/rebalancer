require 'rubygems'
require 'selenium-webdriver'
require 'uuid'
require 'fileutils'

class FetchCSV

  def self.call!
    temp_arr = []
    i = 0
    File.readlines('user_data/info.txt').each do |line, idx|
      temp_arr[i] = line.gsub!("\n","")
      i += 1
    end

    answers = {
      temp_arr[1] => temp_arr[3],
      temp_arr[5] => temp_arr[7],
      temp_arr[9] => temp_arr[11]
    }

    username = temp_arr[13]
    pw = temp_arr[15]

    @download_dir = File.join(Dir.pwd, 'data')
    FileUtils.mkdir_p @download_dir

    if File.file?(@download_dir + '/ofxdownload.csv')
      FileUtils.mv(@download_dir + '/ofxdownload.csv', @download_dir + '/archive/' + Time.new().to_i.to_s, verbose: true)
    end

    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['browser.download.dir'] = @download_dir
    profile['browser.download.folderList'] = 2
    profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/pro_eng, text/csv, application/csv, application/vnd.ms-excel, application/x-ofx'
    # profile['pdfjs.disabled'] = true
    @browser = Selenium::WebDriver.for :firefox, profile: profile

    # my stuff                 

    @browser.get 'https://investor.vanguard.com/my-account/log-on'
    @wait = Selenium::WebDriver::Wait.new(:timeout => 30)


    input_username = wait_for_el("USER")
    input_username.send_keys(username)
    password_field = wait_for_el('PASSWORD')
    password_field.send_keys(pw)
    button = wait_for_el('login')
    button.click

    #challenge

    challenge_question = wait_for_el('LoginForm:summaryTable')
    challenge_question = challenge_question.find_element(css: 'tbody tr:nth-of-type(2) td:nth-of-type(2)')

    current_answer = nil

    answers.keys.each do |answer|
      if answer == challenge_question.text
        current_answer = answers[answer]
      end
    end

    input_challenge = wait_for_el('LoginForm:ANSWER')
    input_challenge.send_keys(current_answer)

    public_computer = wait_for_el('LoginForm:DEVICE:1')
    public_computer.click

    button = wait_for_el('LoginForm:ContinueInput')
    button.click

    @browser.get 'https://personal.vanguard.com/us/OfxWelcome'

    wait_for_el('vg0')
    # @wait.until do 
    #   element = @browser.find_element(:id, 'vg0')
    #   p element.css_value('display')
    #   element.css_value('display') == 'block'
    # end

    dropdown_list = wait_for_el('OfxDownloadForm:downloadOption_main')
    dropdown_list.click

    csv_select = wait_for_el('OfxDownloadForm:downloadOption:_id74')
    csv_select.click

    # check desired accounts
    check = wait_for_el('OfxDownloadForm:selectOrDeselect')
    check.click

    download = wait_for_el('OfxDownloadForm:downloadButtonInput')
    download.click
    p 'download successful'

    @browser.quit
  end

  def self.wait_for_el(id_name)
    @wait.until do
      element = @browser.find_element(:id, id_name)
      if element.displayed?
        element
      end
    end
  end
end
