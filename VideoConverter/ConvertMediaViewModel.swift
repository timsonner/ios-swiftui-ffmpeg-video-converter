//
//  ConvertMediaViewModel.swift
//  VideoConverter
//
//  Created by Timothy Sonner on 6/13/22.
//

import Foundation
import AVFoundation
// #include <ffmpegkit/FFmpegKit.h>
import ffmpegkit

// To use the Objective-C with Swift code:
// Under Build Settings, in Packaging, make sure the Defines Module setting for the framework target is set to Yes.
// Under Build Phases, Link Binary With Libraries, add ffmpegkit.xcframework

class ConvertMediaViewModel: ObservableObject {
    
    func ConvertWithFFMPEG() {
        // removes filename from url path, converts URL to a string, removes encoding
        let decodedURLString = fileURL!.absoluteString.removingPercentEncoding
        // FFmpegSession *session = [FFmpegKit execute:@"-i file1.mp4 -c:v mpeg4 file2.mp4"];
        //must wrap file paths in quotes
//        let session: FFmpegSession = FFmpegKit.execute("-i \"\(decodedURLString!)35.MTS\" \"\(decodedURLString!)w00t.mp4\"")
        
            let foo = fileURL!.lastPathComponent.removingPercentEncoding // file name from path
            let bar = fileURL!.pathExtension // extension of filename
            print("🟢 Debug: last path component: \(foo!)")
            print("🟢 Debug: path extension: \(bar)")
 
        let session: FFmpegSession = FFmpegKit.execute("-version")
        // ReturnCode *returnCode = [session getReturnCode];
        let returnCode = session.getReturnCode()
        
        if fileURL!.startAccessingSecurityScopedResource() {
            session.startRunning() // fires off FFmpegKit.execute()
            print("🟡 Debug: session return code: \(String(describing: returnCode))")
        } else {
            print("🔴 Error: startAccessingSecurityScopedResource() is false")
        }
    }
    
    
    // all views refresh on change
    @Published var importFileName = ""
    @Published var exportFileName = ""
    @Published var selectedFormat: FileExtensionSelection = .mov
    @Published var isShowingPopover = false
    @Published var isShowingFileImporter = false
    @Published var fileURL = URL(string: "")
    
    enum FileExtensionSelection: String, CaseIterable, Identifiable {
        case mp4, mov, m4v
        var id: Self {self}
    }
    
    func sendURLToViewModel(fileURL: URL){
        self.fileURL = fileURL
    }
    
    func ConvertWithAVFoundation(){
            let preset = AVAssetExportPresetHighestQuality
            var outputFileType = AVFileType.mp4 // can be changed
            
            switch selectedFormat {
            case .mp4:
                outputFileType = AVFileType.mp4
            case .mov:
                outputFileType = AVFileType.mov
            case .m4v:
                outputFileType = AVFileType.m4v
            }
            
        if (fileURL?.startAccessingSecurityScopedResource() != nil && exportFileName != "") {
                print("🟢 Debug: get() \(String(describing: fileURL))")
            self.importFileName = fileURL!.lastPathComponent // just the name of the import file, no path
                let anAsset = AVAsset(url: fileURL!) // path to the import file
                let outputURLToString = "\(fileURL!.deletingLastPathComponent())\(exportFileName).\(selectedFormat)" // removes filename from path, adds "." and the user selected filename for export
                let outputURL = URL(string: outputURLToString) // path to save the file to
                
                // Compatability check:
                AVAssetExportSession.determineCompatibility(
                    ofExportPreset: preset,
                    with: anAsset, outputFileType: outputFileType
                ) { isCompatible in
                    guard isCompatible else {
                        print("🔴 Error: Asset not compatible")
                        print("🟡 Debug: selectedformat: \(self.selectedFormat)")
                        print("🟡 Debug: outFileType: \(outputFileType)")
                        return
                    }
                    // Compatibility check succeeded, continue with export.
                    guard let exportSession = AVAssetExportSession(
                        asset: anAsset,
                        presetName: preset) else {
                        print("🟢 Debug: Asset is compatible")
                        return
                    }
                    // Do the work, actually export the file
                    exportSession.outputFileType = outputFileType
                    exportSession.outputURL = outputURL
                    exportSession.exportAsynchronously {
                        // Handle export results.
                    }
                }
        } else {
            print("fileURL or importFilename was nil")
            isShowingPopover.toggle()
        }
    }
}
