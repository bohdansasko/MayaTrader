//
//  QRScannerQRScannerViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit
import AVFoundation

final class QRScannerViewController: CHBaseViewController, QRScannerViewInput {
    var outputProtocol: QRScannerViewOutput!
    var videoLayer : AVCaptureVideoPreviewLayer?
    
    let frameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "icQRExmoFrame")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleNavBar = "Scanning Exmo QR"
        
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

// MARK: - QRScannerViewInput

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

// MARK: Setup views

extension QRScannerViewController {
    
    func setupCloseButton() {
        let icon = #imageLiteral(resourceName: "icWalletClose")
        setupRightBarButtonItem(image: icon, action: #selector(onTouchButtonClose(_:)))
    }
    
    func prepareCameraToReadQRCode() {
        if AVCaptureDevice.authorizationStatus(for: .video) != .authorized {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] isGranted in
                if !isGranted {
                    self?.showAlert(title: "QR Scanner", message: "Unable to access the Camera. \nTo enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.", shouldCloseViewController: true)
                }
                return
            })
        }
        
        let session = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            showAlert(title: "QR Scanner", message: "This device doesn't support capture video throught camera", shouldCloseViewController: true)
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
        videoLayer?.videoGravity = .resizeAspect
        videoLayer?.frame = view.bounds
        if let vl = videoLayer {
            view?.layer.addSublayer(vl)
        }
        
        videoLayer?.session?.startRunning()
    }
}

// MARK: AVCaptureMetadataOutputObjectsDelegate

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ avCaptureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        outputProtocol.tryFetchKeyAndSecret(metadataObjects: metadataObjects)
    }
    
}
