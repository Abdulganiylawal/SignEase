import AVFoundation
import SwiftUI
import UIKit
import Vision
import FirebaseStorage

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
//    var imageView:UIImage! = nil
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            self.session.beginConfiguration()
            self.session.sessionPreset = AVCaptureSession.Preset.high
            // Create a capture device input
            guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                  let deviceInput = try? AVCaptureDeviceInput(device: captureDevice),
                  self.session.canAddInput(deviceInput) else {
                print("Failed to create capture device input.")
                return
            }
           
        
            
            // Add a video data input
            guard self.session.canAddInput(deviceInput) else {
                print("Could not add video device input to the session")
                self.session.commitConfiguration()
                return
            }
            self.session.addInput(deviceInput)
            
            // Add a video data output
            if self.session.canAddOutput(self.videoDataOutput) {
                self.session.addOutput(self.videoDataOutput)
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
         
              
              
                DispatchQueue.main.async {
                    // Create a preview layer
                    self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                    self.previewLayer.videoGravity = .resizeAspectFill
                    // Add the preview layer to the view
                    self.rootLayer = self.view.layer
                    self.previewLayer.frame = self.rootLayer.bounds
                    self.rootLayer.addSublayer(self.previewLayer)
                    // Calling the necessary functions
                    self.setupLayers()
                    self.updateLayerGeometry()
                    self.setupVision()
                }
             
                
                // start the capture
                self.startCaptureSession()
            }
        }
    }
    
    func startCaptureSession(){
        // Start running the session on a global queue
        self.session.startRunning()
        
    }
    func teardownAVCapture() {
        previewLayer.removeFromSuperlayer()
        previewLayer = nil
    }    
}
