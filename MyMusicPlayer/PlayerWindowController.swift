//
//  PlayerWindowController.swift
//  MyMusicPlayer
//
//  Created on 2018/9/27.
//  Copyright © 2018 yume. All rights reserved.
//

import AppKit

class PlayerWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    lazy var playerWindow: PlayerWindow? = {
        let frame: CGRect = CGRect(x: 0, y: 0, width: 480, height: 720)
        let style: NSWindow.StyleMask = [.titled, .closable, .miniaturizable]
        let back: NSWindow.BackingStoreType = .buffered
        let window: PlayerWindow = PlayerWindow(contentRect: frame, styleMask: style, backing: back, defer: false)
        
        window.windowController = self
        
        return window
    }()
    
    lazy var playerViewController: PlayerViewController = {
        let viewController: PlayerViewController = PlayerViewController()
        return viewController
    }()
    
    override init(window: NSWindow?) {
        super.init(window: window)
        self.window = self.playerWindow
        self.contentViewController = self.playerViewController
        self.window?.center()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
