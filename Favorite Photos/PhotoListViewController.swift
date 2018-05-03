//
//  PhotoListViewController.swift
//  Favorite Photos
//
//  Created by David Fisher on 4/30/18.
//  Copyright © 2018 David Fisher. All rights reserved.
//

import UIKit

class PhotoListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

  let photoCellIdentifier = "PhotoCell"
  @IBOutlet weak var collectionView: UICollectionView!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellIdentifier, for: indexPath) as! PhotoViewCell

    // Configure the cell
    cell.captionLabel.text = "Best Photo Ever!"
    cell.imageView.image = #imageLiteral(resourceName: "fab")

    return cell
  }

}








