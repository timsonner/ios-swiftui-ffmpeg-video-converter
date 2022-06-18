//
//  ConvertMediaViewModel.swift
//  VideoConverter
//
//  Created by Timothy Sonner on 6/13/22.
//

import Foundation
import AVFoundation

class ConvertMediaViewModel: ObservableObject {
    // all views refresh on change
    @Published var importFileName = ""
    @Published var exportFileName = ""
    @Published var selectedFormat: FileExtensionSelection = .mov
    @Published var isShowingPupup = false
    @Published var isShowingFileDialog = false
    @Published var fileURL = URL(string: "")
    
    
    enum FileExtensionSelection: String, CaseIterable, Identifiable {
        case mp4, mov, m4v
        var id: Self {self}
    }
    
    func sendURLToViewModel(fileURL: URL){
        self.fileURL = fileURL
    }
    
    func ConvertWithAVFoundation(){
        
            print("start of ConvertWithAVFoundation()")
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
            
        if ((fileURL?.startAccessingSecurityScopedResource()) != nil && exportFileName != "") {
                print("Success: get() \(String(describing: fileURL))")
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
                        print("Failure: Asset not compatible")
                        print("selectedformat: \(self.selectedFormat)")
                        print("outFileType: \(outputFileType)")
                        return
                    }
                    // Compatibility check succeeded, continue with export.
                    guard let exportSession = AVAssetExportSession(
                        asset: anAsset,
                        presetName: preset) else {
                        print("Success: Asset is compatible")
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
            isShowingPupup.toggle()
        }
    }
}
