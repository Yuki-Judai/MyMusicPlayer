//
//  AppDelegate.swift
//  MyMusicPlayer
//
//  Created on 2018/9/27.
//  Copyright © 2018 yume. All rights reserved.
//

import AppKit

//@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    lazy var windowController: PlayerWindowController = {
        let windowController = PlayerWindowController()
        return windowController
    }()
    
    var playerWindowNumber : Int! = nil
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.windowController.showWindow(self)
        
        guard let playerWindow = NSApp.mainWindow else {
            return
        }
        playerWindowNumber = playerWindow.windowNumber
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            let playerWindow : NSWindow? = NSApp.window(withWindowNumber: playerWindowNumber)
            playerWindow?.makeKeyAndOrderFront(sender)
            return true
        }
        else {
            return false
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}
