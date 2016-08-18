//
//  RecordViewController.swift
//  Talkboy
//
//  Created by Jonathan on 3/21/15.
//  Copyright (c) 2015 Jonathan Underwood. All rights reserved.
//

import UIKit
import AVFoundation

extension Notification.Name {
    static let recordedAudioSaved = Notification.Name("recordedAudio.saved")
}

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
                waveformView.waveColor = UIColor.black
            }
        }
    }

    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var waveformView: SiriWaveformView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        audioRecorder = audioRecorder(URL(fileURLWithPath:"/dev/null"))
        audioRecorder.record()

        let displayLink = CADisplayLink(target: self, selector: #selector(updateMeters))
        displayLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }

    @IBAction func tapWaveform(_ sender: UITapGestureRecognizer) {
        if isRecording {
            stopRecordingAudio()
        } else {
            recordAudio()
        }

        isRecording = !isRecording
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showPlayback") {
            let navVC = segue.destination as! UINavigationController
            let playbackVC = navVC.topViewController as! PlaybackViewController
            playbackVC.recordedAudio = sender as! RecordedAudio
        }
    }

    func updateMeters() {
        audioRecorder.updateMeters()
        let normalizedValue = pow(10, audioRecorder.averagePower(forChannel: 0) / 20)
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
        try! AVAudioSession.sharedInstance().setActive(false)
    }

    func timestampedFilePath() -> URL {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.string(from: currentDateTime)+".m4a"
//        let pathArray = [dirPath, recordingName]
//        let filePath = URL.fileURL(withPathComponents: pathArray)
        let filePath = URL(string: "\(dirPath)/\(recordingName)")

        print(filePath!)
        return filePath!
    }

    func audioRecorder(_ filePath: URL) -> AVAudioRecorder {
        let recorderSettings: [String : AnyObject] = [
            AVSampleRateKey: 44100.0 as AnyObject,
            AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),
            AVNumberOfChannelsKey: 2 as AnyObject,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue as AnyObject
        ]

        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)

        let audioRecorder = try! AVAudioRecorder(url: filePath, settings: recorderSettings)
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()

        return audioRecorder
    }

    // MARK: - AVAudioRecorder

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        recordedAudio.filePathUrl = recorder.url
        recordedAudio.title = recorder.url.lastPathComponent

        NotificationCenter.default.post(name: .recordedAudioSaved, object: nil)
        performSegue(withIdentifier: "showPlayback", sender: recordedAudio)
    }
}
