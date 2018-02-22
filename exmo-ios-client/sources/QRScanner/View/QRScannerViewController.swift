//
//  QRScannerQRScannerViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController, QRScannerViewInput, AVCaptureMetadataOutputObjectsDelegate {
    var output: QRScannerViewOutput!
    var videoLayer : AVCaptureVideoPreviewLayer?

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //output.viewIsReady()
        openCamera()
    }

    private func openCamera() {
        let session = AVCaptureSession()
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        } catch {
            print("Can't open camera...")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        videoLayer = AVCaptureVideoPreviewLayer(session: session)
        videoLayer?.frame = view.layer.bounds
        view?.layer.addSublayer(videoLayer!)
        
        session.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    tryParseQRData(object.stringValue)
                }
            }
        }
    }
    
    private func tryParseQRData(_ strData: String?) {
        if let strValue = strData {
            let componentsArr = strValue.components(separatedBy: "|")
            print("key: \(componentsArr[1])")
            print("secret: \(componentsArr[2])")
            
            videoLayer?.session?.stopRunning()
        }
    }
    
    func setupInitialState() {
        // do something
    }
}
