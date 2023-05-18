//
//  VirtualShowroomsApp.swift
//  VirtualShowrooms
//
//  Created by Kelvin J on 5/17/23.
//

import SwiftUI
import ARKit

@main
struct VirtualShowroomsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Perform any necessary setup or initialization here
        if !ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {

            print("does not support AR")
        }
        return true
    }
    
    // Include other AppDelegate methods as needed
}
