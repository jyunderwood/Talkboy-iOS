//
//  PlaybackViewController.swift
//  Talkboy
//
//  Created by Jonathan on 3/21/15.
//  Copyright (c) 2015 Jonathan Underwood. All rights reserved.
//

import UIKit
import AVFoundation

class PlaybackViewController: UIViewController
{
    var audioFile:AVAudioFile!
    var recordedAudio: RecordedAudio!
    var isQueued: Bool = false

    var audioEngine = AVAudioEngine()
    var changePitchEffect = AVAudioUnitTimePitch()
    var audioPlayerNode = AVAudioPlayerNode()

    @IBAction func pauseAction(sender: AnyObject) {
        audioPlayerNode.pause()
    }

    @IBAction func playAction(sender: AnyObject) {
        if !isQueued {
            rewindAction(self)
        }
        audioPlayerNode.play()
    }

    @IBAction func rewindAction(sender: AnyObject) {
        audioPlayerNode.stop()
        audioPlayerNode.reset()

        isQueued = true
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: {
            self.isQueued = false
        })
    }

    @IBAction func changePitch(sender: UISlider) {
        let pitch = sender.value
        changePitchEffect.pitch = pitch
    }

    @IBAction func changeRate(sender: UISlider) {
        let rate = sender.value
        changePitchEffect.rate = rate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = recordedAudio.title

        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true

        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        audioFile = AVAudioFile(forReading: recordedAudio.filePathUrl, error: nil)

        setupAudioEngine()
        rewindAction(self)
    }

    override func didReceiveMemoryWarning() {
        audioPlayerNode.stop()
        audioEngine.stop()
    }

    func setupAudioEngine() {
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioEngine.startAndReturnError(nil)
    }
}
