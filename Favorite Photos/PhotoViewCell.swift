//
//  PhotoViewCell.swift
//  Favorite Photos
//
//  Created by David Fisher on 5/3/18.
//  Copyright © 2018 David Fisher. All rights reserved.
//

import UIKit
import Firebase

class PhotoViewCell: UICollectionViewCell {

  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet weak var captionLabel: UILabel!

  func disply(snapshot: DocumentSnapshot) {
    if let url = snapshot.get("url") as? String {
      ImageUtils.load(imageView: imageView, from: url)
    }
    if let caption = snapshot.get("caption") as? String {
      captionLabel.text = caption
    }
  }
    
}
