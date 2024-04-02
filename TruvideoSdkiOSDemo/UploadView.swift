//
//  UploadView.swift
//  TruvideoSdkiOSDemo
//
//  Created by Luis Francisco Piura Mejia on 2/4/24.
//

import SwiftUI

struct UploadView: View {
    
    @StateObject var viewModel: UploadViewModel
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Upload with id:")
                    Text(viewModel.uploadId)
                }
                Spacer()
                switch viewModel.state {
                case .inProgress:
                    Text("Progress: \(viewModel.progress)%")
                        .layoutPriority(1)
                        .frame(width: 150)
                case .completed:
                    Image(systemName: "checkmark.icloud.fill")
                        .foregroundColor(.green)
                        .layoutPriority(1)
                        .frame(width: 100)
                case .failure, .cancelled:
                    Image(systemName: "checkmark.icloud.fill")
                        .foregroundColor(.red)
                        .layoutPriority(1)
                        .frame(width: 100)
                default:
                    EmptyView()
                }
            }
            switch viewModel.state {
            case .inProgress:
                Button("Cancel") {
                    viewModel.cancel()
                }
                .frame(height: 25)
            case .cancelled:
                Text("Operation cancelled")
                    .foregroundColor(.red)
                    .frame(height: 25)
            case .failure:
                Text("Operation failed")
                    .foregroundColor(.red)
                    .frame(height: 25)
            case let .completed(url):
            Link("Open file", destination: url)
            .frame(height: 25)
            default:
                EmptyView()
            }
        }
        .padding()
    }
    
}
