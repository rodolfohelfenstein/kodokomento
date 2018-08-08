//
//  CameraScanHelper.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 03/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import AVFoundation
import UIKit

struct QRCode {
    var value: String
    var bounds: CGRect
}

protocol CameraScanHelperDelegate: class {
    func didCameraScan(qrcode: QRCode?)
}

class CameraScanHelper: NSObject {
    enum CameraPermission: Int {
        case notDetermined = 0
        case restricted = 1
        case denied = 2
        case authorized = 3
    }

    fileprivate var captureSession: AVCaptureSession?
    fileprivate var captureDevice: AVCaptureDevice?
    fileprivate var captureDeviceInput: AVCaptureDeviceInput?
    fileprivate var captureMetadataOutput: AVCaptureMetadataOutput?
    fileprivate var captureVideoPreviewLayer: AVCaptureVideoPreviewLayer?

    fileprivate weak var _delegate: CameraScanHelperDelegate?

    init(preview: UIView, delegate: CameraScanHelperDelegate?) {
        super.init()

        _delegate = delegate

        preview.subviews.forEach { $0.removeFromSuperview() }
        preview.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .hd1280x720
        captureDevice = AVCaptureDevice.default(for: .video)

        if
            let captureSession = captureSession,
            let captureDevice = captureDevice {
            captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice)
            captureMetadataOutput = AVCaptureMetadataOutput()

            if
                let captureDeviceInput = captureDeviceInput,
                let captureMetadataOutput = captureMetadataOutput,
                captureSession.canAddInput(captureDeviceInput),
                captureSession.canAddOutput(captureMetadataOutput) {
                captureSession.addInput(captureDeviceInput)
                captureSession.addOutput(captureMetadataOutput)

                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
                captureMetadataOutput.metadataObjectTypes = [.qr]

                captureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                captureVideoPreviewLayer?.videoGravity = .resize
                captureVideoPreviewLayer?.connection?.videoOrientation = .portrait
                captureVideoPreviewLayer?.frame = preview.frame

                if let captureVideoPreviewLayer = captureVideoPreviewLayer {
                    preview.layer.addSublayer(captureVideoPreviewLayer)
                }
            }
        }
    }

    static func permission() -> CameraPermission {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

        return CameraPermission(rawValue: authorizationStatus.rawValue) ?? .notDetermined
    }

    static func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in

            if let settingsUrl = URL(string: UIApplicationOpenSettingsURLString), !granted {
                DispatchQueue.main.async {
                    UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                }
            }
        }
    }

    func startScan() {
        captureSession?.startRunning()
    }

    func stopScan() {
        captureSession?.stopRunning()
    }
}

extension CameraScanHelper: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from _: AVCaptureConnection) {
        if
            let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            let metadataValue = metadataObject.stringValue,
            let metadataQrCode = captureVideoPreviewLayer?.transformedMetadataObject(for: metadataObject),
            metadataObject.type == .qr {
            _delegate?.didCameraScan(qrcode: QRCode(value: metadataValue,
                                                    bounds: metadataQrCode.bounds))

        } else {
            _delegate?.didCameraScan(qrcode: nil)
        }
    }
}
