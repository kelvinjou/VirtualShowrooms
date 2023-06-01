//
//  ContentView.swift
//  VirtualShowrooms
//
//  Created by Kelvin J on 5/17/23.
//

import SwiftUI

struct ContentView: View {    
    @State private var submittedExportRequest = false
    
    @State private var submittedName = "" // confirmed that this one will be processed
    var body: some View {
        HStack {
            FetchModel()
            VStack {
                ARViewWrapper(submittedExportRequest: $submittedExportRequest, submittedName: $submittedName)
                    .ignoresSafeArea()
                
                Button("Export") {
                    alertTF(title: "Save file", message: "enter your file name", hintText: "my_file", primaryTitle: "Save", secondaryTitle: "cancel") { text in
                        submittedName = text
                        submittedExportRequest.toggle()
                    } secondaryAction: {
                        print("Cancelled")
                    }

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


extension View {
    func alertTF(title: String, message: String, hintText: String, primaryTitle: String, secondaryTitle: String, primaryAction: @escaping (String) -> (), secondaryAction: @escaping () -> ()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = hintText
        }
        
        alert.addAction(.init(title: secondaryTitle, style: .cancel, handler: { _ in
            secondaryAction()
        }))
        alert.addAction(.init(title: primaryTitle, style: .default, handler: { _ in
            if let text = alert.textFields?[0].text {
                primaryAction(text)
            } else {
                primaryAction("")
            }
        }))
        
        // presenting alert
        rootController().present(alert, animated: true, completion: nil)
    }
    
    
    func rootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}
