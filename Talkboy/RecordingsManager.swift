//
//  RecordingsManager.swift
//  Talkboy
//
//  Created by Jonathan on 8/18/16.
//  Copyright © 2016 Jonathan Underwood. All rights reserved.
//

import Foundation

class RecordingsManager {
    static func timestampedFilePath() -> URL {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.string(from: currentDateTime)+".m4a"
        let filePath = URL(string: "\(dirPath)/\(recordingName)")

        print(filePath!)
        return filePath!
    }

    var dirPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }

    var fileList: [String]! {
        let manager = FileManager.default
        let files = try! manager.contentsOfDirectory(atPath: dirPath)
        return files.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedDescending }
    }

    var count: Int {
        get {
           return fileList.count
        }
    }

    func getFile(atIndex index: Int) -> RecordedAudio {
        let filePath = URL(string: "\(dirPath)/\(fileList[index])")
        let title = fileList[index]
        return RecordedAudio(filePathUrl: filePath!, title: title)
    }

    func deleteFile(atIndex index: Int) {
        let filePath = URL(fileURLWithPath: "\(dirPath)/\(fileList[index])")
        try! FileManager.default.removeItem(at: filePath)
    }
}
