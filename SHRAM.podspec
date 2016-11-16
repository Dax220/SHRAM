#
# Be sure to run `pod lib lint SHRAM.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SHRAM'
  s.version          = '0.1.1'
  s.summary          = 'Simple Http Requests And Mapping'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Shram - is easy to use but powerful framework for communication with RESTful web services via HTTP requests. Shram will help you to send a request to a server in just a few lines of code. The main advantage of this framework is clarity and easy of use. But this is not all the features of Shram. Shram supports mapping objects from the server response. Thus, you can easily query the server for any data and use it now as ready-made objects. But you don't need to build them by hand. Shram will do it for you.
                       DESC

  s.homepage         = 'https://github.com/Dax220/SHRAM'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Maxim Tischenko' => 'maks.tishchenko@gmail.com' }
  s.source           = { :git => 'https://github.com/Dax220/SHRAM.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SHRAM/*'
  
end
