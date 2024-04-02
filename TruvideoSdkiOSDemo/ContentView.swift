//
//  ContentView.swift
//  TruvideoSdkiOSDemo
//
//  Created by Luis Francisco Piura Mejia on 2/4/24.
//

import SwiftUI
import TruvideoSdkCamera

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                if viewModel.isUserAuthenticated {
                    Button("Select files from Camera") {
                        viewModel.presentCamera()
                    }
                } else {
                    Button("Authenticate") {
                        viewModel.authenticate()
                    }
                }
                ForEach($viewModel.uploadViewModels) { viewModel in
                    UploadView(viewModel: viewModel.wrappedValue)
                }
            }
        }
        .padding()
        .presentTruvideoSdkCameraView(isPresented: $viewModel.isCameraPresented) { result in
            viewModel.handle(result: result)
            viewModel.dismissCamera()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
