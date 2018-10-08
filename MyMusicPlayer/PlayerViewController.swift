//
//  PlayerViewController.swift
//  MyMusicPlayer
//
//  Created on 2018/9/27.
//  Copyright © 2018 yume. All rights reserved.
//

import AppKit
import AVFoundation

class PlayerViewController: NSViewController, PlayerViewDragDelegate {
    
    lazy var playerView: PlayerView = {
        let frame: CGRect = CGRect(x: 0, y: 0, width: 320, height: 480)
        let view: PlayerView = PlayerView(frame: frame)
        return view
    }()
    
    private var playerViewModel: PlayerViewModel! = nil
    
    private var playListURLs: [URL] = []
    private var lastPlayedURL: URL! = nil
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.playerView.dragDelegate = self
        self.view = self.playerView
        
        self.setTargetAndActions()
        
        self.loadPlayListReadyToPlay()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadPlayListReadyToPlay() {
        if self.loadPlayList() {
            self.playerViewModel = PlayerViewModel(url: self.lastPlayedURL)
            
            self.playerViewModel.setFileURLs(urls: self.playListURLs)
            self.playerViewModel.saveURLToPlay(url: self.lastPlayedURL)
            
            self.playerViewModel.playerViewController = self
            self.setLastNextBtnEnableState()
            self.playerView.playOrPauseBtn.isEnabled = true
        }
        else {
            return
        }
    }
    
    func dropFileURLsToPlay(view dragView: PlayerView, fileURLs draggedFileURLs: [URL]) {
        if self.playerViewModel != nil {
            self.playerViewModel.removeObservers()
        }
        
        self.playerViewModel = PlayerViewModel(url: draggedFileURLs[0])
        for url in draggedFileURLs {
            self.playerViewModel.saveURL(url: url)
        }
        self.playerViewModel.saveURLToPlay(url: draggedFileURLs[0])
        self.playerViewModel.playerViewController = self
        
        self.savePlayList()
        
        self.setLastNextBtnEnableState()
        self.turnOnPlayBtnAndPlay()
    }
    
}

extension PlayerViewController {
    private func setPlayOrPauseTargetAndAction() {
        self.playerView.playOrPauseBtn.target = self
        self.playerView.playOrPauseBtn.action = #selector(handlePlayOrPause)
    }
    
    @objc
    private func handlePlayOrPause() {
        switch self.playerView.playOrPauseBtn.state {
        case NSControl.StateValue.on:
            if self.playerViewModel.isDidEndPlay() {
                self.playerViewModel.reSetDidEndPlay()
                self.seekToZero()
            }
            self.playerViewModel.playMusic()
        default:
            self.playerViewModel.pauseMusic()
        }
    }
    
    private func setProcessSliderTargetAndAction() {
        self.playerView.processSlider.target = self
        self.playerView.processSlider.action = #selector(seekToTime)
    }
    
    @objc
    private func seekToTime() {
        self.playerViewModel.seekTo(slider: self.playerView.processSlider)
        self.turnOnPlayBtnAndPlay()
    }
    
    private func seekToZero() {
        self.playerViewModel.seekToZero()
    }
    
    private func turnOnPlayBtnAndPlay() {
        self.playerView.playOrPauseBtn.isEnabled = true
        self.playerView.playOrPauseBtn.state = NSControl.StateValue.on
        self.playerViewModel.playMusic()
    }
    
    private func setLastNextMusicTargetAndAction() {
        self.playerView.lastMusicBtn.target = self
        self.playerView.nextMusicBtn.target = self
        self.playerView.lastMusicBtn.action = #selector(handlePlayLast)
        self.playerView.nextMusicBtn.action = #selector(handlePlayNext)
    }
    
    @objc
    private func handlePlayLast() {
        self.playerViewModel.playLast()
        self.setLastNextBtnEnableState()
        self.turnOnPlayBtnAndPlay()
    }
    
    @objc
    private func handlePlayNext() {
        self.playerViewModel.playNext()
        self.setLastNextBtnEnableState()
        self.turnOnPlayBtnAndPlay()
    }
    
    private func setTargetAndActions () {
        self.setPlayOrPauseTargetAndAction()
        self.setProcessSliderTargetAndAction()
        self.setLastNextMusicTargetAndAction()
    }
    
    private func setLastNextBtnEnableState() {
        let btnIsEnable: (lastIsEnable: Bool, nextIsEnable: Bool) = self.playerViewModel.getPlayLastNextBtnIsEnable()
        self.playerView.lastMusicBtn.isEnabled = btnIsEnable.lastIsEnable
        self.playerView.nextMusicBtn.isEnabled = btnIsEnable.nextIsEnable
    }
}

extension PlayerViewController {
    
    private func savePlayList() {
        let fileURLs: [URL] = self.playerViewModel.getFileURLs()
        
        guard fileURLs.count > 0 else {
            UserDefaults.standard.set(false, forKey: "hasPlayList")
            return
        }
        var filePaths: [String] = []
        for url in fileURLs {
            filePaths.append(url.path)
        }
        
        let filePathToPlay: String = self.playerViewModel.getFileURLToPlay().path
        UserDefaults.standard.set(filePaths, forKey: "playListPaths")
        UserDefaults.standard.set(filePathToPlay, forKey: "LastPlayedPath")
        
        UserDefaults.standard.set(true, forKey: "hasPlayList")
        print("Saved Successlly !")
    }
    
    private func loadPlayList() -> Bool {
        guard let hasPlayList: Any = UserDefaults.standard.value(forKey: "hasPlayList"),  (hasPlayList as! Bool) else {
            return false
        }
        let filePaths: [String] = UserDefaults.standard.value(forKey: "playListPaths") as! [String]
        var fileURLs: [URL] = []
        for path in filePaths {
            fileURLs.append(URL(fileURLWithPath: path))
        }
        self.playListURLs = fileURLs
        
        let filePathToPlay: String = UserDefaults.standard.value(forKey: "LastPlayedPath") as! String
        
        self.lastPlayedURL = URL(fileURLWithPath: filePathToPlay)
        
        print("Loaded Successlly !")
        
        return true
    }
}

extension PlayerViewController {
    
    internal func setMusicMetaInfoUI(metaInfo tuple: (title: String, artist: String, totalTime: String, sliderMaxValue: Double, cover: NSImage?)) {
        self.playerView.titleLabel.stringValue = tuple.title
        self.playerView.artistLabel.stringValue = tuple.artist
        self.playerView.totalTimeLabel.stringValue = tuple.totalTime
        self.playerView.processSlider.maxValue = tuple.sliderMaxValue
        if let cover = tuple.cover {
            self.playerView.coverImgBtn.image = cover
        }
        else {
            self.playerView.coverImgBtn.image = NSImage(named: NSImage.touchBarPlayTemplateName)
        }
    }
    
    internal func updateCurTimeAndSliderPositionUI(curTime: String, sliderValue: Double) {
        self.playerView.curtimeLabel.stringValue = curTime
        self.playerView.processSlider.doubleValue = sliderValue
    }
    
    internal func turnOffPlayOrPauseBtn() {
        self.playerView.playOrPauseBtn.state = NSControl.StateValue.off
    }
}
