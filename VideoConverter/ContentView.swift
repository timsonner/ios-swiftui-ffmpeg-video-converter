//
//  ContentView.swift
//  VideoConverter
//
//  Created by Timothy Sonner on 6/11/22.
//

import SwiftUI
import AVFoundation
import UniformTypeIdentifiers

struct ContentView: View {
  
    @ObservedObject var vm = ViewModelFoo()
    @State private var openFile = false
    
    // These settings will encode using H.264.
    let preset = AVAssetExportPresetHighestQuality
    let outFileType = AVFileType.mp4
    let mtsType = UTType(exportedAs: "com.timsonner.mts-document", conformingTo: .video)
    
    var body: some View {
        VStack {
            Image(systemName: "folder")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Button("Open") {
                openFile.toggle()
            }
            .fileImporter(isPresented: $openFile, allowedContentTypes:
                            // custom type added here
                          [.movie], onCompletion: {(res) in
                do {
                    print("start of fileImporter()")
                    let fileURL = try res.get()
                    vm.ConvertWithAVFoundation(fileURL: fileURL)
                } catch {
                    print("Error: get() file")
                    print(error.localizedDescription)
                    
                }
            })
//            .fileImporter(isPresented: $openFile, allowedContentTypes: [mtsType]) { result in
//                        switch result {
//                        case .success(let url):
//                            print(url)
//                            //use `url.startAccessingSecurityScopedResource()` if you are going to read the data
//                        case .failure(let error):
//                            print(error)
//                        }
//                    }
            Text(vm.fileName)
        }
        .padding()
        // end of VStack
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
