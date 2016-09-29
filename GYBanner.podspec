
Pod::Spec.new do |s|

  s.name         = "GYBanner"
  s.version      = "1.0.1"
  s.summary      = "A simple banner view of by swift3.0"
  s.homepage     = "https://github.com/gxq93/GYBanner"
  s.license      = "MIT"
  s.author       = "GuYi"
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/gxq93/GYBanner.git", :tag => s.version }
  s.source_files  = "GYBanner/*.swift"

  # s.public_header_files = "Classes/**/*.h"


  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
