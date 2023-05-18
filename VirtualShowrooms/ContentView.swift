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
        VStack {
            ARViewWrapper(wantsExport: $wantsExport, exportedURL: $exportedURL)
                .ignoresSafeArea()
//                .frame(height: viewModel.imageViewHeight)

            Button("Export") {
//                viewModel.exportButtonTapped()
                wantsExport = true
                
            }
            .padding()
        }
        .sheet(item: $exportedURL) { url in
            ActivityView(activityItems: [url])
        }
        .onAppear {
            viewModel.startARSession()
        }
        .onDisappear {
            viewModel.stopARSession()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
