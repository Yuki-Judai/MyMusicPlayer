//
//  Extensions.swift
//  MyMusicPlayer
//
//  Created on 2018/9/30.
//  Copyright © 2018 yume. All rights reserved.
//

import AppKit
import AVFoundation

extension AVAsset {
    var titleArtist: (title: String , artist: String) {
        var titleArtist: (title: String , artist: String) = (title: "" , artist: "")
        
        for commonMetaDataItem in self.commonMetadata {
            guard let commonKey: AVMetadataKey = commonMetaDataItem.commonKey else {
                return titleArtist
            }
            
            switch commonKey {
            case AVMetadataKey.commonKeyTitle:
                titleArtist.title = commonMetaDataItem.stringValue ?? ""
            case AVMetadataKey.commonKeyArtist:
                titleArtist.artist = commonMetaDataItem.stringValue ?? ""
            default:
                break
            }
        }
        
        return titleArtist
    }
    
    var cover: NSImage? {
        var cover: NSImage? = nil
        
        for commonMetaDataItem in self.commonMetadata {
            guard let commonKey: AVMetadataKey = commonMetaDataItem.commonKey else {
                return cover
            }
            
            if commonKey == AVMetadataKey.commonKeyArtwork , let imgData: Data = commonMetaDataItem.dataValue {
                cover = NSImage(data: imgData)
            }
        }
        
        return cover
}
}
