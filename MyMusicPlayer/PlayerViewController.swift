//
//  PlayerViewController.swift
//  MyMusicPlayer
//
//  Created on 2018/9/27.
//  Copyright © 2018 yume. All rights reserved.
//

import Cocoa
import AVFoundation

class PlayerViewController: NSViewController, PlayerViewDragDelegate {
    
    lazy var playerView: PlayerView = {
        let frame: CGRect = CGRect(x: 0, y: 0, width: 480, height: 600)
        let view: PlayerView = PlayerView(frame: frame)
        return view
    }()
    
    private var playerViewModel: PlayerViewModel! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.playerView.dragDelegate = self
        self.view = self.playerView
        
        self.setTargetAndActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dropFileURLsToPlay(view dragView: PlayerView, fileURLs draggedFileURLs: [URL]) {
        
        if self.playerViewModel != nil {
            self.playerViewModel.removeObservers()
        }
        
        self.playerViewModel = PlayerViewModel(url: draggedFileURLs[0])
        for url in draggedFileURLs {
            self.playerViewModel.fileURLs.append(url)
        }
        self.playerViewModel.fileURLToPlay = draggedFileURLs[0]
        self.playerViewModel.playerViewController = self
        
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
