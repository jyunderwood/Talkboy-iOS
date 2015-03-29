# Talkboy

A voice recording and playback application in Swift.

![Talkboy Demo](https://raw.githubusercontent.com/jyunderwood/Talkboy-iOS/master/assets/talkboy-demo.gif)

I'm working through the iOS / Swift courses in the Udacity "nanodegree", and this is an evolved version of the "pitch perfect" application that is developed in the first course.

## Notable Additions

- File Management - Now you can replay and delete old files
- Recording visualization - A Siri-like waveform view during recording
- Unified playback engine - Now uses `AVAudioEngine` for both speed and pitch effects
- Slider controls - Pitch and speed settings are no longer static buttons but now variable, real-time sliders
- All wrapped in a `UISplitViewController`
