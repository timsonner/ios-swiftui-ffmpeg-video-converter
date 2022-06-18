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
    @ObservedObject var vm = ConvertMediaViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "folder")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Button("Open") {
                vm.isShowingFileDialog.toggle() // toggle var to show file picker
            }
            .fileImporter(isPresented: $vm.isShowingFileDialog, allowedContentTypes:
                            // add custom UTType here for visiblity in file picker (.mts) for example
                          [.movie], onCompletion: {(res) in
                do {
                    let fileURL = try res.get()
                    vm.sendURLToViewModel(fileURL: fileURL)
                } catch {
                    print("Error: get() file")
                    print(error.localizedDescription)
                }
            })
            Text(vm.importFileName)
            Picker("FileFormat", selection: $vm.selectedFormat) {
                ForEach(ConvertMediaViewModel.FileExtensionSelection.allCases) { ext in
                    Text(ext.rawValue.capitalized)
                }
            }
            .pickerStyle(.menu)
            TextField("Export file name", text: $vm.exportFileName, prompt: Text("Export file name"))
            Button("Convert media file") {
                vm.ConvertWithAVFoundation()
            }
        }.padding() // end of VStack
            .popover(isPresented: $vm.isShowingPupup) {
                Text("Choose an export file name or import file")
                    .font(.headline)
                    .padding()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
