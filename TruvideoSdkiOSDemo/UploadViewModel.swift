//
//  UploadViewModel.swift
//  TruvideoSdkiOSDemo
//
//  Created by Luis Francisco Piura Mejia on 2/4/24.
//

import Foundation
import TruvideoSdkMedia
import Combine
import UIKit

final class UploadViewModel: ObservableObject, Identifiable {
    
    enum State {
        case ready
        case inProgress
        case cancelled
        case completed(uploadedFileURL: URL)
        case failure
    }
    
    @Published var state: State = .ready
    @Published var progress = 0
    @Published var uploadId = ""
    @Published var isPaused = false
    
    private var uploadRequest: TruvideoSdkMediaFileUploadRequest?
    private var disposeBag = Set<AnyCancellable>()
    private var backgroundTaskId: UIBackgroundTaskIdentifier?
    
    init(uploadRequest: TruvideoSdkMediaFileUploadRequest? = nil) {
        self.uploadRequest = uploadRequest
        uploadId = uploadRequest?.id ?? ""
        startListening()
    }
    
    func cancel() {
        guard let uploadRequest else { return }
        TruvideoSdkMedia.uploader.cancel(request: uploadRequest)
    }
    
    private func startListening() {
        guard let uploadRequest else { return }
        state = .inProgress
        backgroundTaskId = UIApplication.shared.beginBackgroundTask()
        uploadRequest.completionHandler
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.handle(result: .failure(error))
                }
            }, receiveValue: { [weak self] value in
                self?.handle(result: .success(value))
            })
            .store(in: &disposeBag)

        uploadRequest.progressHandler
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] progress in
                self?.progress = Int(progress.percentage * 100)
            })
            .store(in: &disposeBag)
    }
    
    private func handle(result: Result<TruvideoSdkMediaFileUploadResult, Error>) {
        switch result {
        case .success(let value):
            state = .completed(uploadedFileURL: value.uploadedFileURL)
        case .failure(let error):
            if
                let truvideoError = error as? TruvideoSdkMediaError,
                case .taskCancelledByTheUser = truvideoError {
                state = .cancelled
            } else {
                state = .failure
            }
        }
        guard let backgroundTaskId else {
            return
        }
        UIApplication.shared.endBackgroundTask(backgroundTaskId)
    }
    
}
