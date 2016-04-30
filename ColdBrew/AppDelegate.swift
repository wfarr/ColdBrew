//
//  AppDelegate.swift
//  ColdBrew
//
//  Created by Will Farrington on 4/30/16.
//  Copyright © 2016 Will Farrington. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    
    var caffeinateProcess: NSTask?
    var disabled = true

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let icon = NSImage(named: "statusbar-icon")!
        icon.template = true
        
        statusItem.image = icon
        statusItem.menu = statusMenu
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        switchToDecaf()
    }

    @IBAction func thirtyMinutesClicked(sender: NSMenuItem) {
        caffeinateFor(30)
    }
    
    @IBAction func oneHourClicked(sender: NSMenuItem) {
        caffeinateFor(hours: 1)
    }

    @IBAction func threeHoursClicked(sender: NSMenuItem) {
        caffeinateFor(hours: 3)
    }
    
    @IBAction func oneDayClicked(sender: NSMenuItem) {
        caffeinateFor(hours: 24)
    }
    
    @IBAction func deactivateClicked(sender: NSMenuItem) {
        switchToDecaf()
        disabled = true
    }

    @IBAction func menuQuitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }

    func caffeinateFor(minutes: NSNumber = 0, hours: NSNumber = 0) {
        // if we are re-caffeinating, make sure we kill the old caffeinate first
        switchToDecaf()
        
        var duration = 0
        
        if (hours.integerValue > 0) {
            duration += hours.integerValue * 60 * 60
        }
        
        if (minutes.integerValue > 0) {
            duration += minutes.integerValue * 60
        }
        
        caffeinateProcess = NSTask()
        caffeinateProcess!.launchPath = "/usr/bin/caffeinate"
        caffeinateProcess!.arguments = ["-u", "-t", String(duration)]
        
        caffeinateProcess!.launch()
        
        disabled = false
    }
    
    func switchToDecaf() {
        if (caffeinateProcess?.running == true) {
            caffeinateProcess?.terminate()
            caffeinateProcess?.waitUntilExit()
        }
    }
}

