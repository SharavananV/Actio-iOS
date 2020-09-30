//
//  ActioImagePicker.swift
//  Actio
//
//  Created by apple on 08/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

public protocol ActioPickerDelegate: class {
    func didSelect(url: URL?, type: String)
    func didCaptureImage(_ image: UIImage)
}

extension ActioPickerDelegate {
    func didCaptureImage(_ image: UIImage) {}
}

open class ActioImagePicker: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ActioPickerDelegate?

    public init(presentationController: UIViewController, delegate: ActioPickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
        self.pickerController.videoQuality = .typeHigh
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    public func present(from sourceView: UIView) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//        if let action = self.action(for: .camera, title: "Take video") {
//            alertController.addAction(action)
//        }
        if let action = self.action(for: .camera, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo Album") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect url: URL?, type: String = "") {
        controller.dismiss(animated: true, completion: nil)

        self.delegate?.didSelect(url: url, type: type)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didCaptureImage image: UIImage) {
        controller.dismiss(animated: true, completion: nil)
        
        self.delegate?.didCaptureImage(image)
    }
}

extension ActioImagePicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        if let url = info[.mediaURL] as? URL {
            return self.pickerController(picker, didSelect: url, type: "Video")
        }
        else if let url = info[.imageURL] as? URL {
            return self.pickerController(picker, didSelect: url, type: "Image")
        }
        else if let image = info[.editedImage] as? UIImage {
            return self.pickerController(picker, didCaptureImage: image)
        }

//        //uncomment this if you want to save the video file to the media library
//        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path) {
//            UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, nil, nil)
//        }
        self.pickerController(picker, didSelect: nil)
    }
}

extension ActioImagePicker: UINavigationControllerDelegate {

}

func getDocumentsDirectory() -> URL {
	let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
	return paths[0]
}
