import AVFoundation
import SwiftUI
import UIKit
import Vision

struct CameraView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let cameraViewController = CameraViewController()
        return cameraViewController.view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // No-op
    }
}

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    // MARK: - Properties
   
    private var session: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    var bufferSize: CGSize = .zero
    var rootLayer: CALayer!
    var detectionOverlay: CALayer! = nil
    
    // Vision parts
    var requests = [VNRequest]()
    
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, autoreleaseFrequency: .workItem)
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update the preview layer's frame
        previewLayer?.frame = view.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stop the session when the view disappears
        session?.stopRunning()
        
    }
    
    // MARK: - Private Methods
    
   func setupCamera() {
        // Request camera permissions
      
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard let self = self else { return }
            
            if !granted {
                print("Camera permission denied.")
                return
            }
            
            // Create a capture session
            self.session = AVCaptureSession()
            
            // Create a capture device input
            guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                  let deviceInput = try? AVCaptureDeviceInput(device: captureDevice),
                  self.session.canAddInput(deviceInput) else {
                print("Failed to create capture device input.")
                return
            }
            
            self.session.addInput(deviceInput)
            
            // Add a video data output
            if self.session.canAddOutput(self.videoDataOutput) {
                self.session.addOutput(self.videoDataOutput)
                
                // Add a video data output
                self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
                self.videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
                self.videoDataOutput.setSampleBufferDelegate(self, queue: self.videoDataOutputQueue)
                
                let captureConnection = self.videoDataOutput.connection(with: .video)
                // Always process the frames
                captureConnection?.isEnabled = true
                do {
                    try  captureDevice.lockForConfiguration()
                    let dimensions = CMVideoFormatDescriptionGetDimensions((captureDevice.activeFormat.formatDescription))
                    self.bufferSize.width = CGFloat(dimensions.width)
                    self.bufferSize.height = CGFloat(dimensions.height)
                    captureDevice.unlockForConfiguration()
                } catch {
                    print(error)
                }
                self.session.commitConfiguration()
                // Create a preview layer
                self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                self.previewLayer.videoGravity = .resizeAspectFill
                
             
                    // Add the preview layer to the view
                    self.rootLayer = self.view.layer
                    print(self.view.layer)
                    self.previewLayer.frame = self.rootLayer.bounds
                    self.rootLayer.addSublayer(self.previewLayer)
                
          
                self.setupLayers()
                self.updateLayerGeometry()
                self.setupVision()
                        
                        // start the capture
                self.startCaptureSession()
            }
        }
    }
    
    func startCaptureSession(){
        // Start running the session on a global queue
        
            self.session.startRunning()
        
    }
    public func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation
        
        switch curDeviceOrientation {
        case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
            exifOrientation = .left
        case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
            exifOrientation = .upMirrored
        case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
            exifOrientation = .down
        case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
            exifOrientation = .up
        default:
            exifOrientation = .up
        }
        return exifOrientation
    }
    
}
