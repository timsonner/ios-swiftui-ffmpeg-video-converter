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
    // all views refresh on change
    @Published var fileName = ""
    @Published var userSelectedFormat = ""
    @Published var selectedFormat: AVFileType = .mp4
    @Published var exportFileName = ""
    
    let supportedFormats = [".pls", ".aifc", ".m4r", ".wav", ".3gp", ".3g2", ".flac", ".avi", ".m2a", ".aa", ".aac", ".mpa", ".m3u", ".mov", ".aiff", ".ttml", ".m4v", ".amr", ".caf", ".m4a", ".mp1", ".m1a", ".mp4", ".mp2", ".mp3", ".itt", ".au", ".eac3", ".webvtt", ".vtt", ".ac3", ".m4p", ".mqv"]

    func ConvertWithAVFoundation(fileURL: URL){
        let preset = AVAssetExportPresetHighestQuality
        let outFileType = AVFileType(rawValue: selectedFormat.rawValue) // can be changed
        print("start of fileImporter()")
        if fileURL.startAccessingSecurityScopedResource() {
            print("Success: get() \(fileURL)")
            self.fileName = fileURL.lastPathComponent // just the name of the selected file, no path
            let anAsset = AVAsset(url: fileURL) // path to the file
            // MARK: - Working on it...
            let outputURLToString = "\(fileURL.deletingLastPathComponent())\(exportFileName)\(selectedFormat.rawValue)" // removes filename from path, adds the user selected filename for save
            let outputURL = URL(string: outputURLToString) // path to save the file to
            // Compatability check:
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
                    print("Failure: AVAssetExportSession")
                    return
                }
                // Do the work, actually export the file
                exportSession.outputFileType = outFileType
                exportSession.outputURL = outputURL
                exportSession.exportAsynchronously {
                    // Handle export results.
                }
                print("Asset:\(anAsset)")
//                print("UserFormat:\(userSelectedFormat)")
                print("Export Format:\(self.selectedFormat)")
                print("Export URL:\(outputURLToString)")

            }
        }
        
    }

}
