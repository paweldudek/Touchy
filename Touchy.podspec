Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "Touchy"
  s.version      = "0.0.1"
  s.summary      = "A short description of Touchy."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
                    A longer description of Touchy.
                   DESC

  s.homepage     = "https://github.com/paweldudek/touchy"

  s.license      = "MIT"
  s.author             = { "Paweł Dudek" => "pawel@dudek.mobi" }
  s.social_media_url   = "http://twitter.com/eldudi"

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/paweldudek/touchy.git", :tag => "#{s.version}" }

  s.source_files  = "Sources/Touchy/**/*.swift"
  s.exclude_files = "Tests/**/*"

  s.framework  = "UIKit"
end
