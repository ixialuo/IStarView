Pod::Spec.new do |s|

  s.name         = "IStarView"
  s.version      = "0.0.1"
  s.summary      = "IStarView for iOS swift"
  s.homepage     = "https://github.com/ixialuo/IStarView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "ixialuo" => "ixialuo@gmail.com" }
  s.social_media_url   = "http://blog.csdn.net/ixialuo"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/ixialuo/IStarView.git", :tag => s.version }
  s.source_files  = "Sources/*.swift"
  s.exclude_files = "Classes/Exclude"
  s.requires_arc = true

end
