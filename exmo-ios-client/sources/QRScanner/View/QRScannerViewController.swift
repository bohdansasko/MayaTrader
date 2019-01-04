//
//  QRScannerQRScannerViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController: ExmoUIViewController, QRScannerViewInput {
    var outputProtocol: QRScannerViewOutput!
    var videoLayer : AVCaptureVideoPreviewLayer?
    
    var buttonClose: UIButton = {
        let image = UIImage(named: "icBack")?.withRenderingMode(.alwaysOriginal)
        let button = UIButton(type: .system)
        button.setBackgroundImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        return button
    }()
    
    let frameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icQRFrame")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleNavBar = "QR"
        
        setupCloseButton()
         prepareCameraToReadQRCode()
        
        view.addSubview(frameImageView)
        frameImageView.anchorCenterSuperview()
        
        outputProtocol.viewIsReady()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if videoLayer?.session?.isRunning == false {
            videoLayer?.session?.stopRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if videoLayer?.session?.isRunning == true {
            videoLayer?.session?.stopRunning()
        }
    }
    
    override func shouldUseGlow() -> Bool {
        return false
    }
    
    @objc func onTouchButtonClose(_ sender : UIButton) {
        outputProtocol.closeViewController()
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

// @MARK: setup views
extension QRScannerViewController {
    func setupCloseButton() {
        buttonClose.addTarget(self, action: #selector(onTouchButtonClose(_:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: buttonClose)
    }
    
    func prepareCameraToReadQRCode() {
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
        videoLayer?.videoGravity = .resizeAspectFill
        videoLayer?.frame = view.bounds
        if let vl = videoLayer {
            view?.layer.addSublayer(vl)
        }
        
        videoLayer?.session?.startRunning()
    }
}

// @MARK: AVCaptureMetadataOutputObjectsDelegate
extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ avCaptureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        outputProtocol.tryFetchKeyAndSecret(metadataObjects: metadataObjects)
    }
}
