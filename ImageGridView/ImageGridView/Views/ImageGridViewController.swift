//
//  ImageGridViewController.swift
//  ImageGrid
//
//  Created by Vinoth Kumar GIRI on 15/04/24.
//

import Foundation
import UIKit

import UIKit

class ImageGridViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var images: [ImageData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load initial images
        loadImages()
    }
    
    private func loadImages() {
        // Fetch images from API
        // For this example, we're using a placeholder URL
        guard let url = URL(string: "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error loading images: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                self.images = try JSONDecoder().decode([ImageData].self, from: data)
                print("images \(self.images)")
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print(String(describing: error))
                print("Error decoding images: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    // UICollectionViewDataSource methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let imageData = images[indexPath.item]
        
        if let url = URL(string: imageData.thumbnail.domain + "/" + imageData.thumbnail.basePath + "/" + imageData.thumbnail.key) {
            ImageService.shared.loadImage(from: url) { image, error in
                if let image = image {
                    cell.imageView.image = image
                } else {
                    cell.imageView.image = UIImage(named: "placeholder")
                }
            }
        }
        
        return cell
    }
    
    // UICollectionViewDelegateFlowLayout method
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 - 1
        return CGSize(width: width, height: width)
    }
}

class ImageCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


