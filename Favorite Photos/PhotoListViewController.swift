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

  let photoCellIdentifier = "PhotoCell"
  @IBOutlet weak var collectionView: UICollectionView!

  var dataSnapshots = [DocumentSnapshot]()

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSnapshots.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellIdentifier, for: indexPath) as! PhotoViewCell

    // Configure the cell
//    cell.captionLabel.text = "Best Photo Ever!"
//    cell.imageView.image = #imageLiteral(resourceName: "fab")

    cell.disply(snapshot: dataSnapshots[indexPath.row])

    return cell
  }

  override func uploadImage(_ image: UIImage) {
    print("TODO: Upload the image")
  }

}








