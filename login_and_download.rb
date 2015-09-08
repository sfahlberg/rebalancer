require 'rubygems'
require 'selenium-webdriver'
require 'uuid'
require 'fileutils'

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

profile = Selenium::WebDriver::Firefox::Profile.new
profile['browser.download.dir'] = @download_dir
profile['browser.download.folderList'] = 2
profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/pro_eng, text/csv, application/csv, application/vnd.ms-excel'
# profile['pdfjs.disabled'] = true
BROWSER = Selenium::WebDriver.for :firefox, profile: profile

 # my stuff                 

BROWSER.get 'https://investor.vanguard.com/my-account/log-on'
WAIT = Selenium::WebDriver::Wait.new(:timeout => 20)

def wait_for_el(id_name)
  WAIT.until do
    element = BROWSER.find_element(:id, id_name)
    element if element.displayed?
  end
end

input_username = wait_for_el("USER")
input_username.send_keys(username)
password_field = wait_for_el('PASSWORD')
password_field.send_keys(pw)
button = wait_for_el('login')
button.click

#challenge

challenge_question = wait_for_el('LoginForm:_id88')

current_answer = nil

answers.keys.each do |answer|
  if answer == challenge_question.text
    current_answer = answers[answer]
  else
    puts "unknown challenge question"
  end
end

input_challenge = wait_for_el('comp-LoginForm:ANSWER')
input_challenge.send_keys(current_answer)

public_computer = wait_for_el('_id112')
public_computer.click

button = wait_for_el('LoginForm:continueInput')
button.click

# pw

# password_field = wait_for_el('LoginForm:PASSWORD')
# password_field.send_keys(pw)
#
# button = wait_for_el('LoginForm:submitInput')
# button.click

# check for special event

# if BROWSER.find_element(:id, 'continueInput')
#   continue = BROWSER.find_element(:id, 'continueInput')
#   continue.click
# end

# go to download page
BROWSER.get 'https://personal.vanguard.com/us/OfxWelcome'

# select csv
dropdown_list = wait_for_el('OfxDownloadForm:downloadOption_main')
dropdown_list.click

csv_select = wait_for_el('OfxDownloadForm:downloadOption:_id74')
csv_select.click

# check desired accounts
check = wait_for_el('OfxDownloadForm:selectOrDeselect')
check.click

download = wait_for_el('OfxDownloadForm:downloadButtonInput')
download.click
