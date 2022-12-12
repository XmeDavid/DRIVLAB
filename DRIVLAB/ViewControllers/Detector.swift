import Vision
import AVFoundation
import UIKit

extension CameraController {
    
    func setupDetector() {
        guard let modelURL = Bundle.main.url(forResource: "yolov5sTraffic", withExtension: "mlmodelc") else {
            print("Error - Could not load model")
            return
        }
    
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let recognitions = VNCoreMLRequest(model: visionModel, completionHandler: detectionDidComplete)
            self.requests = [recognitions]
        } catch let error {
            print(error)
        }
    }
    
    func detectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async(execute: {
            if let results = request.results {
                self.extractDetections(results)
            }
        })
    }
    
    func extractDetections(_ results: [VNObservation]) {
        detectionLayer.sublayers = nil
        detectionLayer.zPosition = 1000.0
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else { continue }
            
            let topLabelObservation = objectObservation.labels[0]
            let label = topLabelObservation.identifier
            let confidence = topLabelObservation.confidence
            
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))

            if UserDefaults.standard.bool(forKey: "visualizeDetections") == true {
                let boxLayer = self.drawBoxes(objectBounds, label: label)
                detectionLayer.addSublayer(boxLayer)
            }
            
            if UserDefaults.standard.bool(forKey: "showLabels") == true {
                let labelLayer = self.drawLabels(objectBounds, label: label, confidence: confidence)
                detectionLayer.addSublayer(labelLayer)
            }
            
            detectionLayer.transform  = CATransform3DMakeScale(1, -1, 1)
        }
    }
    
    func setupLayers() {
        detectionLayer = CALayer()
        detectionLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width , height: screenRect.size.height )
        self.view.layer.addSublayer(detectionLayer)
    }
    
    func updateLayers() {
        detectionLayer?.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
    }
    
    func drawLabels(_ bounds: CGRect, label: String, confidence: VNConfidence) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.name = "Object Label"
        
        // Format the string
        let font = UIFont.systemFont(ofSize: 30)
        var colour = Constants.TextColours.light
        
        // Place the labels
        let labelHeight: CGFloat = 40.0
        let yPosOffset: CGFloat = 18.0
        
        if label == "traffic_light_red" {
            textLayer.backgroundColor = Constants.BoxColours.trafficRed
        }
        else if label == "traffic_light_green" {
            textLayer.backgroundColor = Constants.BoxColours.trafficGreen
            colour = Constants.TextColours.dark
        }
        else if label == "traffic_light_na" {
            textLayer.backgroundColor = Constants.BoxColours.trafficNa
            colour = Constants.TextColours.dark
        }
        else if label == "stop sign" {
            textLayer.backgroundColor = Constants.BoxColours.trafficRed
        }
        else if label == "bicycle" || label == "person" {
            textLayer.backgroundColor = Constants.BoxColours.pedestrian
        }
        else {
            textLayer.backgroundColor = Constants.BoxColours.misc
        }
        
        let attribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: colour] as [NSAttributedString.Key : Any]
        let formattedString = NSMutableAttributedString(string: String(format: "\(label) (%.2f)", confidence), attributes: attribute)
        textLayer.string = formattedString
        
        let boxWidth: CGFloat = CGFloat(formattedString.length * 13)
        textLayer.bounds = CGRect(x: 0, y: 0, width: boxWidth, height: labelHeight)
        textLayer.position = CGPoint(x: bounds.minX+(boxWidth/2.0), y: bounds.maxY+yPosOffset)
        
        textLayer.foregroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.0, 0.0, 0.0, 1.0])
        textLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(0)).scaledBy(x: 1.0, y: -1.0))
        return textLayer
    }
    
    func drawBoxes(_ objectBounds: CGRect, label: String) -> CAShapeLayer {
        let boxLayer = CAShapeLayer()
        boxLayer.bounds = objectBounds
        boxLayer.position = CGPoint(x: objectBounds.midX, y: objectBounds.midY)

        boxLayer.cornerRadius = 4.0
        boxLayer.borderWidth = 6.0
        // Box colour depending on label
        // Hierachy: Red > Green > stop sign
        if label == "traffic_light_red" || label == "stop sign" {
            boxLayer.borderColor = Constants.BoxColours.trafficRed
            boxLayer.borderWidth = 12.0
        }
        else if label == "traffic_light_green" {
            boxLayer.borderColor = Constants.BoxColours.trafficGreen
            boxLayer.borderWidth = 10.0
        }
        else if label == "traffic_light_na" {
            boxLayer.borderColor = Constants.BoxColours.trafficNa
            boxLayer.borderWidth = 10.0
        }
        else if label == "person" || label == "bicycle" {
            boxLayer.borderColor = Constants.BoxColours.pedestrian
            boxLayer.borderWidth = 10.0
        }
       
        else {
            boxLayer.borderColor = Constants.BoxColours.misc
        }
        return boxLayer
    }
    
    func drawBoundingBox(_ bounds: CGRect) -> CALayer {
        let boxLayer = CALayer()
        boxLayer.frame = bounds
        boxLayer.borderWidth = 3.0
        boxLayer.borderColor = CGColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        boxLayer.cornerRadius = 4
        return boxLayer
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:]) // Create handler to perform request on the buffer

        do {
            try imageRequestHandler.perform(self.requests) // Schedules vision requests to be performed
        } catch {
            print(error)
        }
    }
}
