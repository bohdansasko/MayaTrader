//
//  QRScannerQRScannerViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController, QRScannerViewInput {
    var outputProtocol: QRScannerViewOutput!
    var videoLayer : AVCaptureVideoPreviewLayer?
    
    func setupInitialState() {
        // do nothing
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setIsHiddenNavTabBar(isHidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        videoLayer?.session?.stopRunning()
        setIsHiddenNavTabBar(isHidden: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        outputProtocol.viewIsReady()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prepareCameraToReadQRCode()
    }
}

// @MARK: UI states
extension QRScannerViewController {
    func setIsHiddenNavTabBar(isHidden: Bool) {
        navigationController?.tabBarController?.tabBar.isHidden = isHidden
    }
}

// @MARK: QRScannerViewInput
extension QRScannerViewController {
    func showAlert(title: String, message: String, shouldCloseViewController: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            [weak self] action in
            if shouldCloseViewController {
                self?.outputProtocol.closeViewController()
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}

// @MARK: AVCapture
extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    private func prepareCameraToReadQRCode() {
        let session = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            showAlert(title: "QR Scanner", message: "This device doesn't support capture video via camera", shouldCloseViewController: true)
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if session.canAddInput(input) {
                session.addInput(input)
            } else {
                showAlert(title: "QR Scanner", message: "This device doesn't support capture video via camera", shouldCloseViewController: true)
                return
            }
        } catch {
            showAlert(title: "QR Scanner", message: "This device doesn't support capture video via camera", shouldCloseViewController: true)
            return
        }
        
        let avCaptureOutput = AVCaptureMetadataOutput()
        session.addOutput(avCaptureOutput)
        avCaptureOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        avCaptureOutput.metadataObjectTypes = [.qr]
        
        videoLayer = AVCaptureVideoPreviewLayer(session: session)
        videoLayer?.frame = view.layer.bounds
        view?.layer.addSublayer(videoLayer!)
        
        session.startRunning()
    }
    
    func metadataOutput(_ avCaptureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        outputProtocol.tryFetchKeyAndSecret(metadataObjects: metadataObjects)
    }
}
