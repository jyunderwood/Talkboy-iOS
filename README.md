# Talkboy

A voice recording and playback application in Swift.

![Talkboy Demo](https://raw.githubusercontent.com/jyunderwood/Talkboy-iOS/master/talkboy-demo.gif)

I'm working through the iOS / Swift courses in the Udacity "nanodegree", and this is an evolved version of the "pitch perfect" application that is developed in the first course.

__Uses Swift 3 and requires Xcode 8 and [Carthage](https://github.com/Carthage/Carthage).__ For a version that uses Swift 2.2, Xcode 7.3 and does not need Carthage, checkout [tag 1.2.0](https://github.com/jyunderwood/Talkboy-iOS/releases/tag/1.2.0).

## Notable Additions

- File Management - Now you can replay and delete old files
- Recording visualization - uses [WaveformView-iOS](https://github.com/jyunderwood/WaveformView-iOS) via Carthage
- Unified playback engine - Now uses `AVAudioEngine` for both speed and pitch effects
- Slider controls - Pitch and speed settings are no longer static buttons but now variable, real-time sliders
- All wrapped in a `UISplitViewController`
