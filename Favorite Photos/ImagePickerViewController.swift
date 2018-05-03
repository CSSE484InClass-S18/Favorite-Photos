//
//  ImagePickerViewController.swift
//  Favorite Photos
//
//  Created by David Fisher on 5/2/18.
//  Copyright © 2018 David Fisher. All rights reserved.
//

import UIKit

class ImagePickerViewController: UIViewController {

  @IBAction func takePhoto(_ sender: Any) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      imagePicker.sourceType = .camera
    } else {
      imagePicker.sourceType = .photoLibrary
    }
    present(imagePicker, animated: true)
  }

  func uploadImage(_ image: UIImage) {
    print("Subclasses should overrite this!")
  }
}

// MARK: UIImagePicker controller delegate methods

extension ImagePickerViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true)
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      // In production I might DO this AND upload.  For this demo JUST upload
      //self.imageView.image = image // Cheat TODO: Delete this line!
      uploadImage(image)
    }
    picker.dismiss(animated: true)
  }
}
