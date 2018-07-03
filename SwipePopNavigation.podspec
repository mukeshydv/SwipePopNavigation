#
#  Be sure to run `pod spec lint SwipePopNavigation.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "SwipePopNavigation"
  s.version      = "0.0.1"
  s.summary      = "SwipePopNavigation is a library for creating a Swipable Navigation Controller"
  s.description  = <<-DESC
            Create Instagram like navigation, Use right swipe to pop back to previous view controller on whole screen.
                   DESC

  s.homepage     = "https://github.com/mukeshydv/SwipePopNavigation"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Mukesh Yadav" => "mails4ymukesh@gmail.com" }

  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/mukeshydv/SwipePopNavigation.git", :tag => "#{s.version}" }

  s.source_files  = "Classes", "Classes/**/*.{swift}"

  s.framework  = "UIKit"
  s.requires_arc = true

  s.swift_version = '>= 4.0'
end
