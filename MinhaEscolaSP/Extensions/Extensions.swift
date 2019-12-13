//  Extensions.swift
//  SEDProfessor
//
//  Created by Victor Bozeli Alvarez on 13/01/19.
//  Copyright (c) 2015 Prodesp. All rights reserved.

import MZFormSheetPresentationController
import UIKit

extension DateFormatter {
    static let mesAno = { () -> DateFormatter in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        return dateFormatter
    }()
}

extension String {
    var base64Decoded: Data? {
        return Data(base64Encoded: self, options: .init(rawValue: 0))
    }

    var base64Encoded: String? {
        let data = self.data(using: .utf8)
        return data?.base64EncodedString(options: .init(rawValue: 0))
    }
}

extension UIAlertController {
    static func createAlert(title: String? = nil, message: String? = nil, style: UIAlertController.Style, actions: [UIAlertAction]? = nil, target: AnyObject?, isPopover: Bool = false, buttonItem: UIBarButtonItem? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        if let actions = actions {
            for action in actions {
                alert.addAction(action)
            }
        }
        else {
            alert.addAction(UIAlertAction(title: Localizable.ok.localized, style: .default))
        }
        if isPopover {
            alert.modalPresentationStyle = .popover
            let popover = alert.popoverPresentationController!
            popover.barButtonItem = buttonItem
            popover.sourceRect = CGRect(x: 0, y: 10, width: 0, height: 0)
            popover.backgroundColor = .white
        }
        DispatchQueue.main.async {
            target?.present(alert, animated: true, completion: nil)
        }
    }
}

extension UICollectionView {
    func dequeue<T: UICollectionViewCell>(index: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: T.className, for: index) as? T
    }
}

extension UIImagePickerController {
    static func mostrarImagePickerController(carteirinha: Bool, viewController: UIViewController & UINavigationControllerDelegate & UIImagePickerControllerDelegate) {
        let temCameraFrontal = UIImagePickerController.isCameraDeviceAvailable(.front)
        let temCameraTraseira = UIImagePickerController.isCameraDeviceAvailable(.rear)
        if temCameraFrontal || temCameraTraseira {
            let cancelar = UIAlertAction(title: Localizable.cancelar.localized, style: .cancel)
            let galeriaDImagens = UIAlertAction(title: Localizable.galeriaDeImagens.localized, style: .default, handler: { (_) in
                mostrarGaleriaDeImagens(viewController: viewController)
            })
            let bibliotecaFotos = UIAlertAction(title: Localizable.bibliotecaDeFotos.localized, style: .default, handler: { (_) in
                let imagePickerController = UIImagePickerController()
                imagePickerController.allowsEditing = true
                imagePickerController.delegate = viewController
                imagePickerController.sourceType = .photoLibrary
                viewController.present(imagePickerController, animated: true)
            })
            let camera = UIAlertAction(title: Localizable.camera.localized, style: .default, handler: { (_) in
                let imagePickerController = UIImagePickerController()
                imagePickerController.allowsEditing = true
                imagePickerController.delegate = viewController
                imagePickerController.sourceType = .camera
                if carteirinha && temCameraFrontal {
                    imagePickerController.cameraDevice = .front
                }
                else {
                    imagePickerController.cameraDevice = .rear
                }
                viewController.present(imagePickerController, animated: true)
            })
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.selecioneAOrigemDaFoto.localized, style: .actionSheet, actions: [bibliotecaFotos, camera, galeriaDImagens, cancelar], target: viewController)
        }
        else {
            mostrarGaleriaDeImagens(viewController: viewController)
        }
    }
    
    fileprivate static func mostrarGaleriaDeImagens(viewController: UIViewController & UINavigationControllerDelegate & UIImagePickerControllerDelegate) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = viewController
        imagePickerController.sourceType = .savedPhotosAlbum
        viewController.present(imagePickerController, animated: true)
    }
}

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>() -> T {
        return instantiateViewController(withIdentifier: T.className) as! T
    }
}

extension UIView {
    func shake() {
        transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}

extension UIViewController {
    func presentFormSheetViewController(height: CGFloat? = nil, viewController: UIViewController) {
        var size: CGSize!
        let sizeWindow = UIApplication.shared.keyWindow!.frame.size
        let width = sizeWindow.width
        let windowHeight = sizeWindow.height
        var topSet = CGFloat(33)
        if UIDevice.current.userInterfaceIdiom == .pad {
            size = CGSize(width: width * 0.65, height: windowHeight * 0.6)
            if let height = height {
                size.height = height
            }
            topSet *= 3
        }
        else {
            let formSheetHeight = windowHeight * 0.83
            size = CGSize(width: width * 0.86, height: windowHeight * 0.83)
            if let height = height, height <= formSheetHeight {
                size.height = height
            }
        }
        let sheetViewController = MZFormSheetPresentationViewController(contentViewController: viewController)
        sheetViewController.contentViewControllerTransitionStyle = .slideAndBounceFromBottom
        let presentationController = sheetViewController.presentationController
        presentationController?.contentViewSize = size
        presentationController?.portraitTopInset = topSet
        presentationController?.landscapeTopInset = topSet
        present(sheetViewController, animated: true)
    }
}
