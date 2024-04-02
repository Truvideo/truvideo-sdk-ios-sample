//
//  TruvideoSdkiOSDemoApp.swift
//  TruvideoSdkiOSDemo
//
//  Created by Luis Francisco Piura Mejia on 2/4/24.
//

import SwiftUI
import TruvideoSdkCamera

@main
struct TruvideoSdkiOSDemoApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return TruvideoSdkCamera.camera.neededOrientation
    }
}

