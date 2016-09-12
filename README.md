# Talkboy

A voice recording and playback application in Swift.

![Talkboy Demo](https://raw.githubusercontent.com/jyunderwood/Talkboy-iOS/master/talkboy-demo.gif)

I'm working through the iOS / Swift courses in the Udacity "nanodegree", and this is an evolved version of the "pitch perfect" application that is developed in the first course.

## Notable Additions

- File Management - Now you can replay and delete old files
- Recording visualization - uses [WaveformView-iOS](https://github.com/jyunderwood/WaveformView-iOS) via Carthage
- Unified playback engine - Now uses `AVAudioEngine` for both speed and pitch effects
- Slider controls - Pitch and speed settings are no longer static buttons but now variable, real-time sliders
- All wrapped in a `UISplitViewController`
