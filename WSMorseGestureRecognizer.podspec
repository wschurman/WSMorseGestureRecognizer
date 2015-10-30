Pod::Spec.new do |s|
  s.name         = "WSMorseGestureRecognizer"
  s.version      = "0.0.3"
  s.summary      = "Gesture Recognizer for Morse Code tap events."
  s.description  = "MorseGestureRecognizer is an extension of UIGestureRecognizer that captures morse code taps and recognizes user-specified events."
  s.license      = "MIT"
  s.author             = { "William Schurman" => "wschurman@fb.com" }
  s.homepage           = "https://github.com/wschurman/WSMorseGestureRecognizer"
  s.social_media_url   = "http://instagram.com/wschurman"

  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/wschurman/WSMorseGestureRecognizer.git", :tag => s.version.to_s }

  s.source_files  = "WSMorseGestureRecognizer/*.{h,m}"
  s.public_header_files = "WSMorseGestureRecognizer/WSMorseGestureRecognizer.h"

  s.requires_arc = true
end
