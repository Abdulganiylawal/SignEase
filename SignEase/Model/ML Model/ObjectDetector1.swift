import UIKit
import SwiftUI
import AVFoundation
import Vision
import FirebaseStorage
import CoreImage
import CoreML



extension CameraViewController:ObservableObject{
    @discardableResult
    func setupVision() -> NSError?{
        let error: NSError! = nil

        guard let modelURL = Bundle.main.url(forResource: "SignDetector", withExtension: "mlmodelc") else {
            return NSError(domain: "VisionObjectRecognitionViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file is missing"])
        }
        do{
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                DispatchQueue.main.async(execute: {
                    if let results = request.results as? [VNRecognizedObjectObservation] {
                        self.drawVisionRequestResults(results)
                        let recognizedObjects = results.compactMap { observation -> (identifier: String, confidence: VNConfidence)? in
                            guard let topLabelObservation = observation.labels.first else {
                                return nil
                            }
                            return (identifier: topLabelObservation.identifier, confidence: topLabelObservation.confidence)
                        }
                          
                        if let firstObject = recognizedObjects.first {
                            if recognizedObjects.count == 1 && firstObject.confidence >= 0.83 {
                                DetectedObjectModal.shared.recognizedObjects = [firstObject.identifier]
                            }
                        }
                        if recognizedObjects.isEmpty {
                            DetectedObjectModal.shared.recognizedObjects = [""]
                        }
                    }
                })
            })
            self.requests = [objectRecognition]
        }catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }
        return error
    }
    func drawVisionRequestResults(_ results: [Any]) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        detectionOverlay.sublayers = nil // remove all the old recognized objects
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            // Select only the label with the highest confidence.
            let topLabelObservation = objectObservation.labels[0]
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))

            let shapeLayer = self.createRoundedRectLayerWithBounds(objectBounds)

            let textLayer = self.createTextSubLayerInBounds(objectBounds,
                                                            identifier: topLabelObservation.identifier,
                                                            confidence: topLabelObservation.confidence)
            shapeLayer.addSublayer(textLayer)
            detectionOverlay.addSublayer(shapeLayer)
        }
        self.updateLayerGeometry()
        CATransaction.commit()
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
//         Create a CIImage from the pixel buffer
//        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)

        // Create a UIImage from the CIImage
//        let context = CIContext()
//        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
//            return
//        }
//        let uiImage = UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .right)
//
//            let error = self.uploadImageToStorage(image: uiImage)
//            print(error)
       
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:])

        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }

//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            do {
//                try imageRequestHandler.perform(self.requests)
//            } catch {
//                print(error)
//            }
//        }
    }
//    
//    func uploadImageToStorage(image: UIImage) -> Error  {
//        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
//            return (UploadError.imageConversionFailed)
//        }
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/png"
//        let fileName = "\(UUID().uuidString).png"
//        let storage = Storage.storage().reference().child("ML").child(fileName)
//        let uploadTask = storage.putData(imageData, metadata: metadata)
//
//        enum UploadError: Error {
//            case imageConversionFailed
//
//        }
//        return (UploadError.imageConversionFailed)
//    }

    func setupLayers() {
        detectionOverlay = CALayer() // container layer that has all the renderings of the observations
        detectionOverlay.name = "DetectionOverlay"
        detectionOverlay.bounds = CGRect(x: 0.0,
                                         y: 0.0,
                                         width: bufferSize.width,
                                         height: bufferSize.height)
        detectionOverlay.position = CGPoint(x: rootLayer.bounds.midX, y: rootLayer.bounds.midY)
        rootLayer.addSublayer(detectionOverlay)
    }

    func updateLayerGeometry() {
        let bounds = rootLayer.bounds
        var scale: CGFloat

        let xScale: CGFloat = bounds.size.width / bufferSize.height
        let yScale: CGFloat = bounds.size.height / bufferSize.width

        scale = fmax(xScale, yScale)
        if scale.isInfinite {
            scale = 1.0
        }
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        // rotate the layer into screen orientation and scale and mirror
        detectionOverlay.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: scale, y: -scale))
        // center the layer
        detectionOverlay.position = CGPoint(x: bounds.midX, y: bounds.midY)
        CATransaction.commit()

    }

    func createTextSubLayerInBounds(_ bounds: CGRect, identifier: String, confidence: VNConfidence) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.name = "Object Label"
        let formattedString = NSMutableAttributedString(string: String(format: "\(identifier)\nConfidence:  %.2f", confidence))
        let largeFont = UIFont(name: "Helvetica", size: 24.0)!
        formattedString.addAttributes([NSAttributedString.Key.font: largeFont], range: NSRange(location: 0, length: identifier.count))
        textLayer.string = formattedString
        textLayer.bounds = CGRect(x: 0, y: 0, width: bounds.size.height - 10, height: bounds.size.width - 10)
        textLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        textLayer.shadowOpacity = 0.7
        textLayer.shadowOffset = CGSize(width: 2, height: 2)
        textLayer.foregroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.0, 0.0, 0.0, 1.0])
        textLayer.contentsScale = 2.0 // retina rendering
        // rotate the layer into screen orientation and scale and mirror
        textLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: 1.0, y: -1.0))
        return textLayer
    }

    func createRoundedRectLayerWithBounds(_ bounds: CGRect) -> CALayer {
        let shapeLayer = CALayer()
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        shapeLayer.name = "Found Object"
        shapeLayer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 0.2, 0.4])
        shapeLayer.cornerRadius = 7
        return shapeLayer
    }

}
