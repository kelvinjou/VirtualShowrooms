//
//  ContentView.swift
//  VirtualShowrooms
//
//  Created by Kelvin J on 5/17/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ExportViewModel()
    
    @State private var submittedExportRequest = false
    @State private var exportedURL: URL?
    
    @State private var wantsExport = false
    @State private var inputName = "" // just the input of what's entered
    @State private var submittedName = "" // confirmed that this one will be processed
    var body: some View {
        HStack {
            FetchModel()
            VStack {
                ARViewWrapper(submittedExportRequest: $submittedExportRequest, exportedURL: $exportedURL, submittedName: submittedName)
                    .ignoresSafeArea()
                
                Button("Export") {
                    wantsExport.toggle()
                    
                }.alert("Enter file name", isPresented: $wantsExport) {
                    TextField("myScan", text: $inputName)
                    Button(action: {
                        submittedName = inputName
                        submittedExportRequest.toggle()
                    }) {
                        Text("Save")
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("A default file name will be given if you leave the text field blank.")
                }
                .padding()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
