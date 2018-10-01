//
//  PlayerWindow.swift
//  MyMusicPlayer
//
//  Created on 2018/9/27.
//  Copyright © 2018 yume. All rights reserved.
//

import Cocoa

class PlayerWindow: NSWindow {
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        self.title = "MyMusicPlayer"
        self.titlebarAppearsTransparent = true
        self.isMovableByWindowBackground = true
        if #available(OSX 10.14, *) {
            self.appearance = NSAppearance(named: NSAppearance.Name.darkAqua)
        } else {
            self.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
        }
    }
}
