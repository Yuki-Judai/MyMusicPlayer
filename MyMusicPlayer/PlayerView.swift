//
//  PlayerView.swift
//  MyMusicPlayer
//
//  Created on 2018/9/27.
//  Copyright © 2018 yume. All rights reserved.
//

import Cocoa

protocol PlayerViewDragDelegate {
    func dropFileURLsToPlay(view dragView : PlayerView, fileURLs draggedFileURLs : [URL])
}

class PlayerView: NSView {
    
    var titleLabel: NSTextField! = nil
    var coverImgBtn: NSButton! = nil
    var artistLabel: NSTextField! = nil
    var curtimeLabel: NSTextField! = nil
    var totalTimeLabel: NSTextField! = nil
    var processSlider: NSSlider! = nil

    var playOrPauseBtn: NSButton! = nil
    var lastMusicBtn: NSButton! = nil
    var nextMusicBtn: NSButton! = nil
    
    var dragDelegate : PlayerViewDragDelegate?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL])
        self.setUpUI()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        
        // Drawing code here.
    }
}

extension PlayerView {
    
    func buildBasicLabel(string: String) -> NSTextField {
        let label: NSTextField = NSTextField(labelWithString: string)
        label.isBordered = false
        label.isBezeled = false
        label.isEditable = false
        label.isSelectable = false
        label.textColor = NSColor.white
        label.alignment = NSTextAlignment.center
        
        return label
    }
    
    func buildTitleLabel()  {
        self.titleLabel = self.buildBasicLabel(string: "Title")
        self.titleLabel.frame = NSRect(x: 0, y: 560, width: 480, height: 20)
    }
    
    func buildArtistLabel()  {
        self.artistLabel = self.buildBasicLabel(string: "Artist")
        self.artistLabel.frame = NSRect(x: 0, y: 260, width: 480, height: 20)
        self.artistLabel.alignment = NSTextAlignment.center
    }
    
    func buildCurtimeLabel()  {
        self.curtimeLabel = self.buildBasicLabel(string: "00:00")
        self.curtimeLabel.frame = NSRect(x: 0, y: 200, width: 100, height: 20)
        self.curtimeLabel.alignment = NSTextAlignment.right
    }
    
    func buildTotalTimeLabel()  {
        self.totalTimeLabel = self.buildBasicLabel(string: "--:--")
        self.totalTimeLabel.frame = NSRect(x: 380, y: 200, width: 100, height: 20)
        self.totalTimeLabel.alignment = NSTextAlignment.left
    }
    
    func buildLabels() {
        self.buildTitleLabel()
        self.buildArtistLabel()
        self.buildCurtimeLabel()
        self.buildTotalTimeLabel()
    }
    
    func buildCoverImgBtn() {
        let initialCoverImg: NSImage = NSImage(named: NSImage.touchBarPlayTemplateName)!
        let button: NSButton = NSButton(image: initialCoverImg, target: nil, action: nil)
        button.isBordered = true
        button.imageScaling = NSImageScaling.scaleProportionallyUpOrDown
        button.bezelStyle = NSButton.BezelStyle.shadowlessSquare
        button.setButtonType(NSButton.ButtonType.momentaryPushIn)
        
        button.frame = NSRect(x: 115, y: 300, width: 250, height: 250)
        button.wantsLayer = true
        button.layer?.cornerRadius = 16
        button.layer?.borderWidth = 6
        button.layer?.borderColor = NSColor.systemGray.cgColor
        
        self.coverImgBtn = button
    }
    
    func buildPlayOrPauseBtn() {
        let initialCoverImg: NSImage = NSImage(named: NSImage.touchBarPlayTemplateName)!
        let alternateImage: NSImage = NSImage(named: NSImage.touchBarPauseTemplateName)!
        let button: NSButton = NSButton(image: initialCoverImg, target: nil, action: nil)
        button.alternateImage = alternateImage
        button.isBordered = false
        button.isEnabled = false
        button.imageScaling = NSImageScaling.scaleNone
        button.bezelStyle = NSButton.BezelStyle.regularSquare
        button.setButtonType(NSButton.ButtonType.toggle)
        button.frame = NSRect(x: 216, y: 100, width: 48, height: 48)
        
        self.playOrPauseBtn = button
    }
    
    func buildLastMusicBtn() {
        let initialCoverImg: NSImage = NSImage(named: NSImage.touchBarGoBackTemplateName)!
        let button: NSButton = NSButton(image: initialCoverImg, target: nil, action: nil)
        button.isBordered = false
        button.isEnabled = false
        button.imageScaling = NSImageScaling.scaleNone
        button.bezelStyle = NSButton.BezelStyle.rounded
        button.setButtonType(NSButton.ButtonType.momentaryPushIn)
        button.frame = NSRect(x: 150, y: 100, width: 48, height: 48)
        
        self.lastMusicBtn = button
    }
    
    func buildNextMusicBtn() {
        let initialCoverImg: NSImage = NSImage(named: NSImage.touchBarGoForwardTemplateName)!
        let button: NSButton = NSButton(image: initialCoverImg, target: nil, action: nil)
        button.isBordered = false
        button.isEnabled = false
        button.imageScaling = NSImageScaling.scaleNone
        button.bezelStyle = NSButton.BezelStyle.rounded
        button.setButtonType(NSButton.ButtonType.momentaryPushIn)
        button.frame = NSRect(x: 284, y: 100, width: 48, height: 48)
        
        self.nextMusicBtn = button
    }
    
    func buildButtons() {
        self.buildCoverImgBtn()
        self.buildPlayOrPauseBtn()
        self.buildLastMusicBtn()
        self.buildNextMusicBtn()
    }
    
    func addLabels() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.artistLabel)
        self.addSubview(self.curtimeLabel)
        self.addSubview(self.totalTimeLabel)
    }
    
    func addButtons() {
        self.addSubview(self.coverImgBtn)
        self.addSubview(self.playOrPauseBtn)
        self.addSubview(self.lastMusicBtn)
        self.addSubview(self.nextMusicBtn)
    }
    
    func buildProcessSlider() {
        let processSlider: NSSlider = NSSlider(frame: NSRect(x: 120, y: 200, width: 250, height: 20))
        processSlider.isContinuous = true
        
        self.processSlider = processSlider
    }
    
    func addProcessSlider() {
        self.addSubview(self.processSlider)
    }
    
    func setUpUI() {
        self.buildLabels()
        self.buildButtons()
        self.buildProcessSlider()
        
        self.addLabels()
        self.addButtons()
        self.addProcessSlider()
    }
}

extension PlayerView {
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        
        let pasteboard: NSPasteboard = sender.draggingPasteboard
        let audiovisualcontent: CFString = kUTTypeAudiovisualContent
        let filteringOptions: [NSPasteboard.ReadingOptionKey : CFString]  = [NSPasteboard.ReadingOptionKey.urlReadingFileURLsOnly : audiovisualcontent]
        
        if pasteboard.canReadObject(forClasses: [NSURL.self], options: filteringOptions) {
            return NSDragOperation.copy
        }
        else {
            return NSDragOperation.generic
        }
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        
        var fileURLs : [URL] = []
        
        guard let draggingPasteboardItems: [NSPasteboardItem] = sender.draggingPasteboard.pasteboardItems else {
            return false
        }
        
        for draggingPasteboardItem in draggingPasteboardItems {
            if let pboardFilePath: String = draggingPasteboardItem.string(forType: NSPasteboard.PasteboardType.fileURL) , let fileURL : URL = URL.init(string: pboardFilePath) {
                fileURLs.append(fileURL)
            }
        }
        
        self.dragDelegate?.dropFileURLsToPlay(view: self, fileURLs: fileURLs)
        
        return true
    }
}
