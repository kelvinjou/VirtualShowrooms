//
//  FetchModel.swift
//  VirtualShowrooms
//
//  Created by Kelvin J on 5/18/23.
//

import SwiftUI
import SceneKit


struct FetchModel: View {
    @State private var fileNames: [String] = []
    @State var fileName = ""
    @State var fullScreen = false
    var body: some View {
        VStack {
            List(fileNames, id: \.self) { fileName in
                Button(action: {
                    print(fileName)
                    self.fileName = fileName
                    fullScreen.toggle()
                }) {
                    HStack {
                        Text(fileName)
                        Spacer()
                        Image(systemName: "eye.fill")
                    }
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive, action: {
                        removeFile(fileName: fileName)
                        withAnimation {
                            fetchFiles()
                        }
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .refreshable {
                fetchFiles()
            }
            
            .fullScreenCover(isPresented: $fullScreen) {
                ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                    if !fileName.isEmpty {
                        SceneViewWrapper(scene: displayFile(fileName: self.fileName)).id(fileName)
                    }
                    Button(action: {
                        fullScreen = false
                    }) {
                        Text("Back").padding()
                    }
                }
                
            }
            
        }
        .onAppear {
            fetchFiles()
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
            let filteredURLs = fileURLs.filter { (url) -> Bool in
                return url.pathExtension == "obj"
            }
            
            self.fileNames = filteredURLs.map { $0.lastPathComponent }
        } catch {
            print("Error fetching files: \(error)")
        }
    }
    
    func displayFile(fileName: String) -> SCNScene {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Failed to access documents directory.")
        }
        
        let folderName = "OBJ_FILES"
        let folderURL = directory.appendingPathComponent(folderName)
        let fileURL = folderURL.appendingPathComponent(fileName)
        
        let sceneView = try? SCNScene(url: fileURL)
        return sceneView ?? SCNScene()
    }
    
    func removeFile(fileName: String) {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Failed to access documents directory.")
        }
        
        let folderName = "OBJ_FILES"
        let folderURL = directory.appendingPathComponent(folderName)
        let fileURL = folderURL.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("File removed successfully: \(fileURL)")
        } catch {
            print("Error removing file: \(error)")
        }
    }
}

struct SceneViewWrapper: UIViewRepresentable {
    let scene: SCNScene?
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        scnView.antialiasingMode = .multisampling2X
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .ambient // Set the light type (e.g., .omni, .directional, .spot, .ambient)
        lightNode.light?.color = UIColor.white // Set the light color
        // lightNode.position = SCNVector3(x: 0, y: 3, z: 0) // Set the position of the light node
        scene?.rootNode.addChildNode(lightNode)
        
        scnView.scene = scene
        scnView.backgroundColor = .clear
        return scnView
    }
    func updateUIView(_ uiView: SCNView, context: Context) {    }
}
