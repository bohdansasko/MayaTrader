//
//  QRScannerQRScannerViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, QRScannerViewInput {
    var outputProtocol: QRScannerViewOutput!
    var videoLayer : AVCaptureVideoPreviewLayer?

    func setupInitialState() {
        // do nothing
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outputProtocol.viewIsReady()
        prepareCameraToReadQRCode()
    }

    private func prepareCameraToReadQRCode() {
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
        outputProtocol.tryFetchKeyAndSecret(metadataObjects: metadataObjects)
    }

    func dismissView() {
        videoLayer?.session?.stopRunning()
        self.navigationController?.popViewController(animated: true)
    }
}
