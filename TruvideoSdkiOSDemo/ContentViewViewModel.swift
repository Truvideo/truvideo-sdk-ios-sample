//
//  ContentViewViewModel.swift
//  TruvideoSdkiOSDemo
//
//  Created by Luis Francisco Piura Mejia on 2/4/24.
//

import Foundation
import TruvideoSdk
import TruvideoSdkMedia
import TruvideoSdkCamera
import UIKit

final class ContentViewViewModel: ObservableObject {
    
    @Published private(set) var isUserAuthenticated = false
    @Published var uploadViewModels = [UploadViewModel]()
    @Published var isCameraPresented = false
    
    init() {
        isUserAuthenticated = TruvideoSdk.isAuthenticated && !TruvideoSdk.isAuthenticationExpired
    }

    @MainActor
    func authenticate() {
        Task { @MainActor in
            let isAuthenticated = TruvideoSdk.isAuthenticated
            let isAuthenticationExpired = TruvideoSdk.isAuthenticationExpired
            if !isAuthenticated || isAuthenticationExpired {
                let apiKey = "YourApiKey"
                let yourSecret = "YourSecret"
                let payload = TruvideoSdk.generatePayload()
                // We strongly recommend the generation of the signature to be performed in the backend side
                let signature = payload.toSha256String(using: yourSecret)
                do {
                    try await TruvideoSdk.authenticate(apiKey: apiKey, payload: payload, signature: signature)
                    isUserAuthenticated = true
                } catch {
                    // Handle error
                }
            } else {
                do {
                    try await TruvideoSdk.´init´()
                    isUserAuthenticated = true
                } catch {
                    // Handle error
                }
            }
        }
    }
    
    func presentCamera() {
        isCameraPresented.toggle()
    }
    
    func dismissCamera() {
        isCameraPresented.toggle()
    }
    
    func handle(result: TruvideoSdkCameraResult) {
        result.photos.forEach { photo in
            uploadFile(at: photo.url)
        }
        result.clips.forEach { clip in
            uploadFile(at: clip.url)
        }
    }
    
    private func uploadFile(at url: URL) {
        let uploadRequest = TruvideoSdkMedia.uploader.uploadFile(at: url)
        uploadViewModels.insert(UploadViewModel(uploadRequest: uploadRequest), at: 0)
    }
}

