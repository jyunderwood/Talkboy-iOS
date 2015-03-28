//
//  RecordViewController.swift
//  Talkboy
//
//  Created by Jonathan on 3/21/15.
//  Copyright (c) 2015 Jonathan Underwood. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate
{
    var audioRecorder: AVAudioRecorder!
    var recordedAudio = RecordedAudio()
    var isRecording: Bool = false {
        didSet {
            if isRecording {
                recordLabel.text = "Tap to Stop"
                waveformView.waveColor = UIColor(red:0.928, green:0.103, blue:0.176, alpha:1)
            } else {
                recordLabel.text = "Tap to Record"
                waveformView.waveColor = UIColor.blackColor()
            }
        }
    }

    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var waveformView: SiriWaveformView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        audioRecorder = audioRecorder(NSURL(fileURLWithPath:"/dev/null")!)
        audioRecorder.record()

        var displayLink = CADisplayLink(target: self, selector: Selector("updateMeters"))
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }

    @IBAction func tapWaveform(sender: UITapGestureRecognizer) {
        if isRecording {
            stopRecordingAudio()
        } else {
            recordAudio()
        }

        isRecording = !isRecording
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showPlayback") {
            let navVC = segue.destinationViewController as UINavigationController
            let playbackVC = navVC.topViewController as PlaybackViewController
            playbackVC.recordedAudio = sender as RecordedAudio
        }
    }

    func updateMeters() {
        audioRecorder.updateMeters()
        var normalizedValue = pow(10, audioRecorder.averagePowerForChannel(0) / 20)
        waveformView.updateWithLevel(CGFloat(normalizedValue))
    }

    func recordAudio() {
        audioRecorder.stop()
        audioRecorder = audioRecorder(timestampedFilePath())
        audioRecorder.delegate = self
        audioRecorder.record()
    }

    func stopRecordingAudio() {
        audioRecorder.stop()
        AVAudioSession.sharedInstance().setActive(false, error: nil)
    }

    func timestampedFilePath() -> NSURL {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".m4a"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)

        println(filePath)
        return filePath!
    }

    func audioRecorder(filePath: NSURL) -> AVAudioRecorder {
        let recorderSettings = [
            AVSampleRateKey: 44100.0,
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue
        ]

        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)

        var audioRecorder = AVAudioRecorder(URL: filePath, settings: recorderSettings, error: nil)
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()

        return audioRecorder
    }

    // MARK: - AVAudioRecorder

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent

            NSNotificationCenter.defaultCenter().postNotificationName("recordedAudio.saved", object: nil)
            performSegueWithIdentifier("showPlayback", sender: recordedAudio)
        } else {
            println("Error")
        }
    }
}
