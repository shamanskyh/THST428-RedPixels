//
//  ViewController.swift
//  ProjectionHighlight
//
//  Created by Harry Shamansky on 4/19/15.
//  Copyright (c) 2015 Harry Shamansky. All rights reserved.
//

import UIKit
import AVFoundation
import CoreVideo
import CoreGraphics

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    var captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    var captureInput: AVCaptureDeviceInput?
    var captureOutput: AVCaptureVideoDataOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetLow
        
        captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        var err1: NSError?
        captureInput = AVCaptureDeviceInput(device: captureDevice!, error: &err1)
        
        captureSession.addInput(captureInput)
        
        captureOutput = AVCaptureVideoDataOutput()
        captureOutput?.videoSettings = [kCVPixelBufferPixelFormatTypeKey : kCVPixelFormatType_32BGRA]
        captureOutput?.connectionWithMediaType(AVMediaTypeVideo)?.enabled = true
        let videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL)
        captureOutput?.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        
        
        captureSession.addOutput(captureOutput)
        
//        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        
//        previewView.layer.addSublayer(previewLayer)
//        previewLayer?.frame = self.view.layer.frame
        
        captureSession.startRunning()
        
    }
    
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        CVPixelBufferLockBaseAddress(imageBuffer, 0)
        
        // Throw to Objective-C here to process low-level memory
        // Get back an array of points that were detected
        let manager = BufferToArray()
        let arr = manager.detectPixelsInBuffer(imageBuffer)
        
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0)
       
        
        UIGraphicsBeginImageContext(CGSize(width: CVPixelBufferGetWidth(imageBuffer), height: CVPixelBufferGetHeight(imageBuffer)))
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        var rects = convertPointsToRects(arr)
        CGContextFillRects(context, &rects, rects.count)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        dispatch_async(dispatch_get_main_queue()) {
            self.imageView.image = img
            self.imageView.setNeedsDisplay()
        }
        
        
        UIGraphicsEndImageContext()
        
    }
    
    func makeZoomedRect(view: CGRect, zoomFactor: CGFloat) -> CGRect {
        return CGRect(x: view.width / zoomFactor, y: view.height / zoomFactor, width: view.width - ((view.width / zoomFactor) * 2), height: view.height - ((view.height / zoomFactor) * 2))
    }
    
    func convertPointsToRects(points: [AnyObject]) -> [CGRect] {
        var retRects: [CGRect] = []
        for point in (points as! [NSValue]) {
            let cgp = point.CGPointValue()
            let rect = CGRect(origin: cgp, size: CGSize(width: 5, height: 3))
            retRects.append(rect)
        }
        return retRects
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

