//
//  PlayerViewModel.swift
//  MyMusicPlayer
//
//  Created on 2018/9/27.
//  Copyright © 2018 yume. All rights reserved.
//

import AppKit
import AVFoundation

class PlayerViewModel: NSObject {
    
    private var playerInstance: AVPlayer! = nil
    private var playbackTimerObserver: Any? = nil
    internal var playerViewController: PlayerViewController? = nil
    internal var fileURLs: [URL] = []
    internal var fileURLToPlay: URL! = nil
    
    init(url: URL) {
        super.init()
        
        _ = self.createPlayerInstance(with: self.createPlayerItem(with: url))
    }
    
    private func addPlayerItemKVO() {
        self.playerInstance.currentItem!.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            guard let keyValueChangeNew = change?[NSKeyValueChangeKey.newKey] as? Int else {
                return
            }
            guard let itemStatus : AVPlayerItem.Status = AVPlayerItem.Status(rawValue: keyValueChangeNew) else {
                return
            }
            
            switch itemStatus {
                
            case AVPlayerItem.Status.unknown:
                break
            case AVPlayerItem.Status.readyToPlay:
                let musicMetaInfo: (title: String, cover: NSImage?, artist: String, totalTime: String, sliderMaxValue: Double) = self.getMusicMetaInfoTuple()
                self.playerViewController?.setMusicMetaInfoUI(metaInfo: musicMetaInfo)
                self.createTimerObserver()
                break
            case AVPlayerItem.Status.failed:
                break
            default:
                break
            }
            
        }
    }
    
    private func getMusicMetaInfoTuple() -> (title: String, cover: NSImage?, artist: String, totalTime: String, sliderMaxValue: Double) {
        var musicMetaInfo: (title: String, cover: NSImage?, artist: String, totalTime: String, sliderMaxValue: Double) = (title: "", cover: nil, artist: "", totalTime: "", sliderMaxValue: 0.0)
        
        let titleArtist: (title: String, artist: String) = self.playerInstance.currentItem!.asset.titleArtist
        musicMetaInfo.title = titleArtist.title
        musicMetaInfo.artist = titleArtist.artist
        let totalTimeDouble: Double = Util.convertCMTimeToSeconds(time: self.playerInstance.currentItem!.duration)!
        musicMetaInfo.sliderMaxValue = totalTimeDouble
        let totalTimeString: String = Util.convertSecondsForReading(second: totalTimeDouble)
        musicMetaInfo.totalTime = totalTimeString
        
        if let cover = self.playerInstance.currentItem!.asset.cover {
            musicMetaInfo.cover = cover
        }
        else {
            musicMetaInfo.cover = NSImage(named: NSImage.touchBarPlayTemplateName)
        }
        
        return musicMetaInfo
    }
    
    private func createTimerObserver() {
        
        if self.playbackTimerObserver == nil {
            self.playbackTimerObserver = self.playerInstance.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: nil, using: { (time : CMTime) in
                self.playerViewController?.playerView.processSlider.doubleValue = Double(Util.convertCMTimeToSeconds(time: time) ?? 0)
                self.playerViewController?.playerView.curtimeLabel.stringValue = Util.convertSecondsForReading(second: Util.convertCMTimeToSeconds(time: time) ?? 0)
            })
        }
        else {
            self.playbackTimerObserver = nil
            self.createTimerObserver()
        }
    }
    
    internal func removeObservers() {
        
        self.playerInstance.currentItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        if self.playbackTimerObserver != nil {
            self.playerInstance.removeTimeObserver(self.playbackTimerObserver!)
            self.playbackTimerObserver = nil
        }
    }
}

extension PlayerViewModel {
    
    private func checkFileExisits(at url: URL) -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    private func createPlayerInstance(with item: AVPlayerItem?) -> Bool {
        
        let playerInstance: AVPlayer = AVPlayer(playerItem: item)
        
        self.playerInstance = playerInstance
        
        self.addPlayerItemKVO()
        
        return true
    }
    
    private func createPlayerItem(with url: URL) -> AVPlayerItem? {
        
        guard self.checkFileExisits(at: url) else {
            return nil
        }
        
        let playerItem: AVPlayerItem = AVPlayerItem(url: url)
        
        return playerItem
    }
    
    private func getIndexOfPlayingFile(in fileURLs : [URL]) -> Int? {
        
        guard fileURLs.count > 0 else {
            return nil
        }
        
        let indexOfPlayingFileInPaths : Array<URL>.Index? = fileURLs.firstIndex(of: self.fileURLToPlay)
        guard let curIndex = indexOfPlayingFileInPaths , curIndex < fileURLs.count else {
            return nil
        }
        
        return curIndex
    }
    
    private func getPlayLastNextBtnIsEnable(curIndex: Int) -> (lastIsEnable: Bool, nextIsEnable: Bool) {
        
        if self.fileURLs.count == 1 {
            return (lastIsEnable: false, nextIsEnable: false)
        }
        else if self.fileURLs.count > 1 && curIndex == 0 {
            return (lastIsEnable: false, nextIsEnable: true)
        }
        else if self.fileURLs.count > 1 && curIndex + 1 == self.fileURLs.count {
            return (lastIsEnable: true, nextIsEnable: false)
        }
        else {
            return (lastIsEnable: true, nextIsEnable: true)
        }
    }
    
}

extension PlayerViewModel {
    
    internal func playMusic() {
        self.playerInstance.play()
    }
    
    internal func pauseMusic() {
        self.playerInstance.pause()
    }
    
    internal func playLast() {
        guard let curIndex : Int = self.getIndexOfPlayingFile(in: self.fileURLs) else {
            return
        }
        if curIndex - 1 >= 0 {
            self.removeObservers()
            _ = self.createPlayerInstance(with: self.createPlayerItem(with: self.fileURLs[curIndex - 1]))
            self.fileURLToPlay = self.fileURLs[curIndex - 1]
        }
    }
    
    internal func playNext() {
        guard let curIndex : Int = self.getIndexOfPlayingFile(in: self.fileURLs) else {
            return
        }
        if curIndex + 1  < self.fileURLs.count {
            self.removeObservers()
            _ = self.createPlayerInstance(with: self.createPlayerItem(with: self.fileURLs[curIndex + 1]))
            self.fileURLToPlay = self.fileURLs[curIndex + 1]
        }
    }
    
    internal func seekTo(slider: NSSlider) {
        self.playerInstance.seek(to: CMTime(seconds: slider.doubleValue, preferredTimescale: 100), toleranceBefore: CMTimeMake(value: 1, timescale: 100), toleranceAfter: CMTimeMake(value: 1, timescale: 100))
    }
    
    internal func getIndexOfPlayingFile() -> Int? {
        return self.getIndexOfPlayingFile(in: self.fileURLs)
    }
    
    internal func getPlayLastNextBtnIsEnable() -> (lastIsEnable: Bool, nextIsEnable: Bool) {
        guard let curIndex : Int = self.getIndexOfPlayingFile(in: self.fileURLs) else {
            return (lastIsEnable: false, nextIsEnable: false)
        }
        return self.getPlayLastNextBtnIsEnable(curIndex: curIndex)
    }
}
