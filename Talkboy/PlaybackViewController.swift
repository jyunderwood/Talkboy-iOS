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
    var audioFile: AVAudioFile!
    var recordedAudio: RecordedAudio!
    var isQueued: Bool = false

    var audioEngine = AVAudioEngine()
    var changePitchEffect = AVAudioUnitTimePitch()
    var audioPlayerNode = AVAudioPlayerNode()

    @IBAction func pauseAction(_ sender: AnyObject) {
        audioPlayerNode.pause()
    }

    @IBAction func playAction(_ sender: AnyObject) {
        if !isQueued {
            rewindAction(self)
        }
        audioPlayerNode.play()
    }

    @IBAction func rewindAction(_ sender: AnyObject) {
        audioPlayerNode.stop()
        audioPlayerNode.reset()

        isQueued = true
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: {
            self.isQueued = false
        })
    }

    @IBAction func changePitch(_ sender: UISlider) {
        let pitch = sender.value
        changePitchEffect.pitch = pitch
    }

    @IBAction func changeRate(_ sender: UISlider) {
        let rate = sender.value
        changePitchEffect.rate = rate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = recordedAudio.title

        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true

        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try! audioFile = AVAudioFile(forReading: recordedAudio.filePathUrl as URL)

        setupAudioEngine()
        rewindAction(self)
    }

    override func didReceiveMemoryWarning() {
        audioPlayerNode.stop()
        audioEngine.stop()
    }

    func setupAudioEngine() {
        audioEngine.attach(audioPlayerNode)
        audioEngine.attach(changePitchEffect)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        try! audioEngine.start()
    }
}
