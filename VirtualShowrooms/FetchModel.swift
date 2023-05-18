//
//  FetchModel.swift
//  VirtualShowrooms
//
//  Created by Kelvin J on 5/18/23.
//

import SwiftUI

struct FetchModel: View {
    @State private var fileNames: [String] = []

    var body: some View {
        VStack {
            Button(action: {
                fetchFiles()
            }) {
                Text("Fetch Files")
            }

            List(fileNames, id: \.self) { fileName in
                Text(fileName)
            }
        }
    }
    func fetchFiles() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let folderName = "OBJ_FILES" // Replace with the folder name you want to access
        let folderURL = documentsDirectory.appendingPathComponent(folderName)
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
            self.fileNames = fileURLs.map { $0.lastPathComponent }
        } catch {
            print("Error fetching files: \(error)")
        }
    }
}
