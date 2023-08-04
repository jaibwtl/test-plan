require 'rubygems'
require 'selenium-webdriver'
USER_NAME = ENV['BROWSERSTACK_USERNAME'] || "YOUR_USERNAME"
ACCESS_KEY = ENV['BROWSERSTACK_ACCESS_KEY'] || "YOUR_ACCESS_KEY"
def run_session(bstack_options)
  options = Selenium::WebDriver::Options.send "chrome"
  options.browser_name = bstack_options["browserName"].downcase
  options.add_option('bstack:options', bstack_options)
  driver = Selenium::WebDriver.for(:remote,
                                   :url => "http://localhost:4444/wd/hub",
                                   :capabilities => options)
  begin

    driver.navigate.to "http://35.92.143.29"
    element = driver.find_element(name: 'n1')
    element.send_keys 12
    element2 = driver.find_element(name: 'n2')
    element2.send_keys 12
    element3 = driver.find_element(id: 'add')
    element3.click
    element4 = driver.find_element(name: 'n4')
    print(element4.text)

    # marking test as 'failed' if test script is unable to open the bstackdemo.com website
  rescue
    driver.execute_script('browserstack_executor: {"action": "setSessionStatus", "arguments": {"status":"failed", "reason": "Some elements failed to load"}}')
  end
  driver.quit
end
BUILD_NAME = "browserstack-build-1"
caps = [{
          "os" => "Windows",
          "osVersion" => "11",
          "browserName" => "Chrome",
          "buildName" => BUILD_NAME,
          "sessionName" => "Ruby thread 1"
        }]
t1 = Thread.new{ run_session(caps[0]) }
t1.join()
