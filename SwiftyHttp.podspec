#
# Be sure to run `pod lib lint SwiftyHttp.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftyHttp'
  s.version          = '2.5'
  s.summary          = 'Simple Http Requests'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
SwiftyHttp - is easy to use but powerful framework for communication with RESTful web services via HTTP requests. SwiftyHttp will help you to send a request to a server in just a few lines of code. The main advantage of this framework is clarity and easy of use. 
                       DESC

  s.homepage         = 'https://github.com/Dax220/Swifty_HTTP'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Maxim Tischenko' => 'maks.tishchenko@gmail.com' }
  s.source           = { :git => 'https://github.com/Dax220/Swifty_HTTP.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SwiftyHttp/*'
  s.dependency 'SwiftyJSON'

end
