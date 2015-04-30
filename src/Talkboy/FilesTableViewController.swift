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
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
    }

    var fileList: [NSString]! {
        let manager = NSFileManager.defaultManager()
        let files = manager.contentsOfDirectoryAtPath(dirPath, error: nil) as! [NSString]
        return files.sorted { $0.localizedCaseInsensitiveCompare($1 as String) == NSComparisonResult.OrderedDescending }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "recordedAudioInserted:",
            name: "recordedAudio.saved",
            object: nil)
    }

    override func didReceiveMemoryWarning() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showPlayback") {
            let audioFile = RecordedAudio()
            let indexPath = tableView.indexPathForSelectedRow()
            let pathArray = [dirPath, fileList[indexPath!.row]]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)

            audioFile.filePathUrl = filePath
            audioFile.title = fileList[indexPath!.row] as! String

            let navVC = segue.destinationViewController as! UINavigationController
            let playbackVC = navVC.topViewController as! PlaybackViewController
            playbackVC.recordedAudio = audioFile
        }
    }

    // MARK: - Table view data source

    func recordedAudioInserted(notification: NSNotification) {
        tableView.reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("fileCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = fileList[indexPath.row] as String

        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let pathArray = [dirPath, fileList[indexPath.row]]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)

            NSFileManager.defaultManager().removeItemAtURL(filePath!, error: nil)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}
