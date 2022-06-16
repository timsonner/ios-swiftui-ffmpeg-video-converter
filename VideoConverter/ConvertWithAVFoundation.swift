//
//  ConvertWithAVFoundation.swift
//  VideoConverter
//
//  Created by Timothy Sonner on 6/13/22.
//

import Foundation
import AVFoundation
import UniformTypeIdentifiers

class ViewModelFoo: ObservableObject {
    @Published var fileName = "" // all views refresh on change
    func ConvertWithAVFoundation(fileURL: URL){
        let preset = AVAssetExportPresetHighestQuality
        let outFileType = AVFileType.mp4 // can be changed
        let supportedExtensions = ["pls", "aifc", "m4r", "wav", "3gp", "3g2", "flac", "avi", "m2a", "aa", "aac", "mpa", "m3u", "mov", "aiff", "ttml", "m4v", "amr", "caf", "m4a", "mp4", "mp1", "m1a", "mp4", "mp2", "mp3", "itt", "au", "eac3", "webvtt", "vtt", "ac3", "m4p", "mqv"]

        let mtsType = UTType(exportedAs: "com.timsonner.mts-document", conformingTo: .video)
        print("start of fileImporter()")
        
        if fileURL.startAccessingSecurityScopedResource() {
            print("Success: get() \(fileURL)")
            self.fileName = fileURL.lastPathComponent
            let anAsset = AVAsset(url: fileURL)
            // Your source AVAsset movie in HEVC format //
            let outputURLToString = "\(fileURL.deletingLastPathComponent())fff.mp4"
            let outputURL = URL(string: outputURLToString)
            // URL of your exported output //
            AVAssetExportSession.determineCompatibility(
                ofExportPreset: preset,
                with: anAsset, outputFileType: outFileType
            ) { isCompatible in
                guard isCompatible else {
                    print("Failure: Asset not compatible")
                    return
                }
                // Compatibility check succeeded, continue with export.
                guard let exportSession = AVAssetExportSession(
                    asset: anAsset,
                    presetName: preset) else {
                    print("Success: Asset is compatible")
                    return
                }
                exportSession.outputFileType = outFileType
                exportSession.outputURL = outputURL
                exportSession.exportAsynchronously {
                    // Handle export results.
                }
            }
        }
        
    }

}
