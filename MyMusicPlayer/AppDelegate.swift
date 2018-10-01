//
//  AppDelegate.swift
//  MyMusicPlayer
//
//  Created on 2018/9/27.
//  Copyright © 2018 yume. All rights reserved.
//

import Cocoa

//@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    lazy var windowController: PlayerWindowController = {
        let windowController = PlayerWindowController()
        return windowController
    }()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        self.windowController.showWindow(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

