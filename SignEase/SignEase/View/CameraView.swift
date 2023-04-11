import AVFoundation
import SwiftUI
import UIKit

struct CameraView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let cameraViewController = CameraViewController()
        return cameraViewController.view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // no-op
    }
}

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var session: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request camera permissions
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if !granted {
                print("Camera permission denied.")
                return
            }
            
            // Create a capture session
            self.session = AVCaptureSession()
            
            // Create a capture device input
            guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
                  let deviceInput = try? AVCaptureDeviceInput(device: captureDevice),
                  self.session.canAddInput(deviceInput) else {
                print("Failed to create capture device input.")
                return
            }
            
            // Create a capture video data output
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video"))
            
            // Add input and output to the session
            self.session.addInput(deviceInput)
            self.session.addOutput(videoOutput)
            
            // Create a preview layer
            self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
            self.previewLayer.videoGravity = .resizeAspectFill
            
            // Add the preview layer to the view
            DispatchQueue.main.async {
                self.view.layer.insertSublayer(self.previewLayer, at: 0)
            }
            
            // Start the session
            self.session.startRunning()
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Handle the captured video sample buffer
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let previewLayer = self.previewLayer else {
            return
        }
        
        // Update the preview layer's frame
        previewLayer.frame = self.view.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stop the session when the view disappears
        self.session.stopRunning()
    }
}
