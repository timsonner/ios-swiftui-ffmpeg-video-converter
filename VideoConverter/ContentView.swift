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
                            // custom type added here for visiblity in selection
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
            
            Text(vm.fileName)
        }
        .padding()
        Picker("FileFormat", selection: $vm.selectedFormat) {
            ForEach(vm.supportedFormats.sorted().reversed(), id: \.self) {
                Text($0)
            }
        }
        .pickerStyle(.menu)
        TextField("Export file name", text: $vm.exportFileName, prompt: Text("New file name"))
    }
    
        // end of VStack
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
