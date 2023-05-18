//
//  ARWrapper.swift
//  VirtualShowrooms
//
//  Created by Kelvin J on 5/17/23.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewWrapper: UIViewRepresentable {
    
    @Binding var wantsExport: Bool
    @Binding var exportedURL: URL?
    let arView = ARView(frame: .zero)
    func makeUIView(context: Context) -> ARView {
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        setARViewOptions(arView)
        let configuration = buildConfigure()
        arView.session.run(configuration)
        
        if wantsExport {
            var exportedURL: URL?
            guard let camera = arView.session.currentFrame?.camera else {return}
            
            if let meshAnchors = arView.session.currentFrame?.anchors.compactMap({ $0 as? ARMeshAnchor }),
               let asset = ExportViewModel().convertToAsset(meshAnchors: meshAnchors, camera: camera) {
                do {
                    let url = try ExportViewModel().export(asset: asset)
                    exportedURL = url
                    
                } catch {
                    print("Export error")
                }
            }
        }
    }
    
    private func setARViewOptions(_ arView: ARView) {
        arView.debugOptions.insert(.showSceneUnderstanding)
    }
    func share(url: URL) {
        let vc = UIActivityViewController(activityItems: [url],applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    private func buildConfigure() -> ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.environmentTexturing = .automatic
        configuration.sceneReconstruction = .mesh
        if type(of: configuration).supportsFrameSemantics(.sceneDepth) {
            configuration.frameSemantics = .sceneDepth
        }
        
        return configuration
    }
}

class ExportViewModel: NSObject, ObservableObject, ARSessionDelegate {
    @Published var imageViewHeight: CGFloat = 0
    @Published var exportedURL: URL?

    private var arView: ARView?
    private var camera: ARCamera?

    func startARSession() {
        arView?.session.delegate = self
    }

    func stopARSession() {
        arView?.session.pause()
        arView = nil
    }
    
    func exportButtonTapped() {
            guard let camera = camera else { return }

            if let meshAnchors = arView?.session.currentFrame?.anchors.compactMap({ $0 as? ARMeshAnchor }),
               let asset = convertToAsset(meshAnchors: meshAnchors, camera: camera) {
                do {
                    let url = try export(asset: asset)
                    exportedURL = url
                } catch {
                    print("Export error")
                }
            }
        }
     func convertToAsset(meshAnchors: [ARMeshAnchor], camera: ARCamera) -> MDLAsset? {
        guard let device = MTLCreateSystemDefaultDevice() else { return nil }
        
        let asset = MDLAsset()
        
        for anchor in meshAnchors {
            let mdlMesh = anchor.geometry.toMDLMesh(device: device, camera: camera, modelMatrix: anchor.transform)
            asset.add(mdlMesh)
        }
        
        return asset
    }
    
    func share(url: URL) {
        let vc = UIActivityViewController(activityItems: [url],applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    func export(asset: MDLAsset) throws -> URL {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw NSError(domain: "com.original.VirtualShowrooms", code: 153)
        }
        
        let folderName = "OBJ_FILES" // Replace with the desired folder name
        let folderURL = directory.appendingPathComponent(folderName)
        
        // Create the folder if it doesn't exist
        try? FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        
        let url = folderURL.appendingPathComponent("\(UUID().uuidString).obj")
        
        do {
            try asset.export(to: url)
            print("Object saved successfully at: ", url)

            return url
        } catch {
            print("Error saving .obj file \(error)")
        }
        
        return url
    }
}
