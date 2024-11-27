//
//  CameraStore.swift
//  DeviceClassifier
//
//  Created by Tomáš Pařízek on 27.11.2024.
//

import AVFoundation
import Vision
import SwiftUI

final class CameraStore: NSObject, ObservableObject {

    // MARK: - Public properties

    @Published var observations = [String: Float]()

    var captureSession = AVCaptureSession()

    // MARK: - Private properties

    private var isDetecting = false
    private let captureSessionQueue = DispatchQueue(label: "captureSessionQueue")
    private var coreMlRequest: VNCoreMLRequest?

    // MARK: - Lifecycle

    override init() {
        super.init()

        Task {
            await initialize()
        }
    }

    // MARK: - Public functions

    func onAppear() {
        captureSessionQueue.async {
            self.captureSession.startRunning()
        }
    }

    func onDisappear() {
        captureSessionQueue.async {
            self.captureSession.stopRunning()
        }
    }
}

// MARK: - Private

private extension CameraStore {
    func initialize() async {
        await requestPermissionIfNeeded()
        setupCaptureInput()
        setupCaptureOutput()
        setupModel()
    }

    func requestPermissionIfNeeded() async {
        guard AVCaptureDevice.authorizationStatus(for: .video) != .authorized else {
            return
        }

        _ = await AVCaptureDevice.requestAccess(for: .video)
    }

    func setupCaptureInput() {
        guard
            let videoDevice = AVCaptureDevice.default(for: .video),
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
            captureSession.canAddInput(videoDeviceInput) == true
        else {
            return
        }

        captureSession.addInput(videoDeviceInput)
    }

    func setupCaptureOutput() {
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.setSampleBufferDelegate(self, queue: captureSessionQueue)
        captureSession.addOutput(videoDataOutput)
    }

    func setupModel() {
        // TODO: Create a VNCoreMLModel for your CoreML Classifier Model
        // Hint, initialize the generated model class and use the `.model` property
        let model = try! VNCoreMLModel(
            for: ...
        )
        coreMlRequest = VNCoreMLRequest(
            model: model,
            completionHandler: handleModelOutput
        )
    }

    func handleModelOutput(request: VNRequest, error: Error?) {
        defer {
            isDetecting = false
        }

        // TODO: Handle results
        // Steps:
        // 1. cast `request.results` to `VNClassificationObservation`
        // 2. create [String: Float] dictionary
        // 3. iterate over observations array and fill the dictionary with data (identifier and confidence properties are your friends)
        // 4. assing filled dictionary to self.observations on main thread
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraStore: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        guard
            !isDetecting,
            let coreMlRequest,
            let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        else { return }

        let image = CIImage(
            cvPixelBuffer: pixelBuffer
        ).transformed(by: .init(rotationAngle: -.pi/2))

        let handler = VNImageRequestHandler(ciImage: image, options: [:])

        try? handler.perform([coreMlRequest])
    }
}
