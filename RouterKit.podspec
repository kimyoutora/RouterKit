Pod::Spec.new do |s|
  s.name             = "RouterKit"
  s.version          = "0.1.0"
  s.summary          = "Simple but powerful router written in Swift to help manage deep linking and navigation of your app's content."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
RouterKit is an elegant way to isolate and manage all the hairy navigation logic between the view controllers and deep links into your application.
It offers a clean way to define routes, pass data, manage transition logic that are often littered throughout view controllers and makes your code much more readable.
                       DESC

  s.homepage         = "https://github.com/kimyoutora/routerkit"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.authors          = { "Kang Chen" => "kangchen614@gmail.com", "Chase Latta" => "clatta@twitter.com" }
  s.source           = { :git => "https://github.com/kimyoutora/routerkit.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/routerkit'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'RouterKit/**/*'

  # s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
