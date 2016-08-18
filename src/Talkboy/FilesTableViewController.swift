//
//  FilesTableViewController.swift
//  Talkboy
//
//  Created by Jonathan on 3/21/15.
//  Copyright (c) 2015 Jonathan Underwood. All rights reserved.
//

import UIKit

class FilesTableViewController: UITableViewController
{
    var dirPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }

    var fileList: [String]! {
        let manager = FileManager.default
        let files = try! manager.contentsOfDirectory(atPath: dirPath)
        return files.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedDescending }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(recordedAudioInserted(_:)), name: .recordedAudioSaved, object: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showPlayback") {
            let audioFile = RecordedAudio()
            let indexPath = tableView.indexPathForSelectedRow
//            let pathArray = [dirPath, fileList[indexPath!.row]]
//            let filePath = URL.fileURL(withPathComponents: pathArray)
            let filePath = URL(string: "\(dirPath)/\(fileList[indexPath!.row])")

            audioFile.filePathUrl = filePath
            audioFile.title = fileList[(indexPath! as NSIndexPath).row]

            let navVC = segue.destination as! UINavigationController
            let playbackVC = navVC.topViewController as! PlaybackViewController
            playbackVC.recordedAudio = audioFile
        }
    }

    // MARK: - Table view data source

    func recordedAudioInserted(_ notification: Notification) {
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fileCell", for: indexPath)
        cell.textLabel?.text = fileList[(indexPath as NSIndexPath).row] as String

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            let pathArray = [dirPath, fileList[indexPath.row]]
//            let filePath = URL.file(withPathComponents: pathArray)
            let filePath = URL(fileURLWithPath: "\(dirPath)/\(fileList[indexPath.row])")

            try! FileManager.default.removeItem(at: filePath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
