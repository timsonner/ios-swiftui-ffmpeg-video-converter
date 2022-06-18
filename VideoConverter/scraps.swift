////
////  scraps.swift
////  VideoConverter
////
////  Created by Timothy Sonner on 6/12/22.
////
//
//import Foundation
//

// import UniformTypeIdentifiers
// custom type, mostly just for a test
// let mtsType = UTType(exportedAs: "com.timsonner.mts-document", conformingTo: .video)


// example file importer:
//struct ContentView : View {
//    @State private var presentImporter = false
//
//    var body: some View {
//        Button("Open") {
//            presentImporter = true
//        }.fileImporter(isPresented: $presentImporter, allowedContentTypes: [.pdf]) { result in
//            switch result {
//            case .success(let url):
//                print(url)
//                //use `url.startAccessingSecurityScopedResource()` if you are going to read the data
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//}

// Another file importer

//            .fileImporter(isPresented: $openFile, allowedContentTypes: [mtsType]) { result in
//                        switch result {
//                        case .success(let url):
//                            print(url)
//                            //use `url.startAccessingSecurityScopedResource()` if you are going to read the data
//                        case .failure(let error):
//                            print(error)
//                        }
//                    }
