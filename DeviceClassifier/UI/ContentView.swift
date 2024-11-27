//
//  ContentView.swift
//  DeviceClassifier
//
//  Created by Tomáš Pařízek on 27.11.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var cameraStore = CameraStore()

    var body: some View {
        CameraPreview(session: cameraStore.captureSession)
            .edgesIgnoringSafeArea(.all)
            .overlay(alignment: .bottom) {
                if !cameraStore.observations.isEmpty {
                    ObservationsView(observations: cameraStore.observations)
                }
            }
            .onAppear {
                cameraStore.onAppear()
            }
            .onDisappear {
                cameraStore.onDisappear()
            }
    }
}

#Preview {
    ContentView()
}
