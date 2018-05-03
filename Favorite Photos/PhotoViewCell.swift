//
//  PhotoViewCell.swift
//  Favorite Photos
//
//  Created by David Fisher on 5/1/18.
//  Copyright © 2018 David Fisher. All rights reserved.
//

import UIKit
import Firebase

class PhotoViewCell: UICollectionViewCell {
    
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var captionLabel: UILabel!

  func display(snapshot: DocumentSnapshot) {
    if let imageUrl = snapshot.get("url") as? String {
      ImageUtils.load(imageView: imageView, from: imageUrl)
    }
//    imageView.image = #imageLiteral(resourceName: "fab")
    if let caption = snapshot.get("caption") as? String {
      captionLabel.text = caption
    }
  }
}
