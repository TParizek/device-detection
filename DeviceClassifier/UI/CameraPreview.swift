//
//  CameraPreview.swift
//  DeviceClassifier
//
//  Created by Tomáš Pařízek on 27.11.2024.
//

import AVFoundation
import SwiftUI

struct CameraPreview: UIViewRepresentable {
    var session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(previewLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
