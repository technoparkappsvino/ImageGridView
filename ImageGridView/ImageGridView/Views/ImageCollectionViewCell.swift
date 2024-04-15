//
//  ImageCollectionViewCell.swift
//  ImageGrid
//
//  Created by Vinoth Kumar GIRI on 15/04/24.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(with image: UIImage?) {
        imageView.image = image
    }
}

