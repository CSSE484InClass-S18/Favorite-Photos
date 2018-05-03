//
//  PhotoListViewController.swift
//  Favorite Photos
//
//  Created by David Fisher on 4/30/18.
//  Copyright © 2018 David Fisher. All rights reserved.
//

import UIKit
import Firebase

class PhotoListViewController: ImagePickerViewController, UICollectionViewDelegate, UICollectionViewDataSource {

  var photosRef: CollectionReference!
  var photosListener: ListenerRegistration!
  var photosStorageRef: StorageReference!

  let photoCellIdentifier = "PhotoCell"
  var dataSnapshots = [DocumentSnapshot]()

  let itemsPerRow = 2
  let sectionInsets = UIEdgeInsets(top: 30.0, left: 5.0, bottom: 30.0, right: 5.0)

  @IBOutlet weak var collectionView: UICollectionView!
  override func viewDidLoad() {
    super.viewDidLoad()
    photosStorageRef = Storage.storage().reference(withPath: "photos")
    photosRef = Firestore.firestore().collection("photos")
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    photosListener = photosRef.order(by: "created", descending: true).limit(to: 10).addSnapshotListener({ (querySnapshot, error) in
      if let querySnapshot = querySnapshot {

        let source = querySnapshot.metadata.hasPendingWrites ? "Local" : "Server"
        let fromCache = querySnapshot.metadata.isFromCache ? " using cache" : " not using cache"
        print("Reload all the data!!!!")
        print(source + fromCache)

        self.dataSnapshots = querySnapshot.documents
        self.collectionView.reloadData()
      }
    })
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    photosListener.remove()
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSnapshots.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellIdentifier, for: indexPath) as! PhotoViewCell

    //cell.captionLabel.text = "TODO: Fix"
    cell.display(snapshot: dataSnapshots[indexPath.row])

    return cell
  }

  func getCaption(_ documentRef: DocumentReference) {
    print("Get the caption for this image")
    let ac = UIAlertController(title: "Set image caption", message: "optional", preferredStyle: .alert)
    ac.addTextField { (textField) in
      textField.placeholder = "Image caption"
    }
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) in
      let captionTextField = ac.textFields![0]
      documentRef.updateData(["caption" : captionTextField.text!])
    }
    ac.addAction(okAction)
    present(ac, animated: true, completion: nil)
  }


  override func uploadImage(_ image: UIImage) {
//    guard let data = UIImageJPEGRepresentation(image, 0.5) else { return }
    guard let data = ImageUtils.resize(image: image, maxHeight: 500, maxWidth: 500) else { return }

    let photoDocumentRef = photosRef.document()
    let photoStorageRef = photosStorageRef.child(photoDocumentRef.documentID)

    let uploadMetadata = StorageMetadata()
    uploadMetadata.contentType = "image/jpeg"

    DispatchQueue.main.async { // Then update on main thread
      self.getCaption(photoDocumentRef)
    }
    photoStorageRef.putData(data, metadata: uploadMetadata) {(metadata, error) in
      if let error = error {
        print("Error with upload \(error.localizedDescription)")
      }
      photoStorageRef.downloadURL(completion: { (url, error) in
        if let error = error {
          print("Error getting the download url. \(error.localizedDescription)")
        }
        if let url = url {
          print("Saving the url \(url.absoluteString)")
          // Save the download url to the Firestore
          photoDocumentRef.setData(["url" : url.absoluteString,
                                    "caption": "best photo ever",
                                    "created": Date()])
        }
      })
    }
  }
}

extension PhotoListViewController : UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let paddingSpace = sectionInsets.left * CGFloat(itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / CGFloat(itemsPerRow)
    return CGSize(width: widthPerItem, height: widthPerItem)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}
