//
//  main.swift
//  MyMusicPlayer
//
//  Created on 2018/9/27.
//  Copyright © 2018 yume. All rights reserved.
//

import Cocoa

func mainMenu() -> NSMenu {
    let mainMenu : NSMenu = NSMenu()
    let mainAppMenuItem : NSMenuItem = NSMenuItem(title: "Application", action: nil, keyEquivalent: "")
    let mainFileMenuItem : NSMenuItem =  NSMenuItem(title: "File", action: nil, keyEquivalent: "")
    mainMenu.addItem(mainAppMenuItem)
    mainMenu.addItem(mainFileMenuItem)
    
    let appMenu : NSMenu = NSMenu()
    mainAppMenuItem.submenu =  appMenu
    
    let appServicesMenu : NSMenu = NSMenu()
    NSApp.servicesMenu = appServicesMenu
    appMenu.addItem(withTitle: "About", action: nil, keyEquivalent: "")
    appMenu.addItem(NSMenuItem.separator())
    appMenu.addItem(withTitle: "Preferences...", action: nil, keyEquivalent: ",")
    appMenu.addItem(NSMenuItem.separator())
    appMenu.addItem(withTitle: "Hide", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")
    appMenu.addItem({ ()->NSMenuItem in
        let m = NSMenuItem(title: "Hide Others", action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h")
        m.keyEquivalentModifierMask = NSEvent.ModifierFlags([.command, .option])
        return m
        }())
    appMenu.addItem(withTitle: "Show All", action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: "")
    
    appMenu.addItem(NSMenuItem.separator())
    appMenu.addItem(withTitle: "Services", action: nil, keyEquivalent: "").submenu =  appServicesMenu
    appMenu.addItem(NSMenuItem.separator())
    appMenu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
    
    let fileMenu : NSMenu = NSMenu(title: "File")
    mainFileMenuItem.submenu = fileMenu
    fileMenu.addItem(withTitle: "Open...[TODO]", action: #selector(NSDocumentController.newDocument(_:)), keyEquivalent: "o")
    
    return mainMenu
}

autoreleasepool {
    let app : NSApplication = NSApplication.shared
    let delegate : AppDelegate = AppDelegate()
    app.delegate =  delegate
    app.mainMenu = mainMenu()
    app.run()
}
