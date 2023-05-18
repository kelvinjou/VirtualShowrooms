//
//  ContentView.swift
//  VirtualShowrooms
//
//  Created by Kelvin J on 5/17/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ExportViewModel()
    @State var wantsExport = false
    @State private var exportedURL: URL?
    var body: some View {
        HStack {
            FetchModel()
            VStack {
                ARViewWrapper(wantsExport: $wantsExport, exportedURL: $exportedURL)
                    .ignoresSafeArea()
                
                Button("Export") {
                    wantsExport = true
                    
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
