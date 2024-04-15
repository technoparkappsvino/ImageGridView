//
//  ImageService.swift
//  ImageGridView
//
//  Created by Vinoth Kumar GIRI on 15/04/24.
//

import UIKit

class ImageService {
    static let shared = ImageService()
    
    private var memoryCache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func loadImage(from url: URL, completion: @escaping (UIImage?, Error?) -> Void) {
        // Check memory cache
        if let image = memoryCache.object(forKey: url.absoluteString as NSString) {
            completion(image, nil)
            return
        }
        
        // Load image from disk cache or network
        DispatchQueue.global().async {
            if let image = self.loadImageFromDisk(url: url) {
                self.memoryCache.setObject(image, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async {
                    completion(image, nil)
                }
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, let image = UIImage(data: data), error == nil else {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }
                
                self.memoryCache.setObject(image, forKey: url.absoluteString as NSString)
                self.saveImageToDisk(image: image, url: url)
                
                DispatchQueue.main.async {
                    completion(image, nil)
                }
            }.resume()
        }
    }
    
    private func loadImageFromDisk(url: URL) -> UIImage? {
        let path = self.getFilePath(for: url)
        return UIImage(contentsOfFile: path)
    }
    
    private func saveImageToDisk(image: UIImage, url: URL) {
        let path = self.getFilePath(for: url)
        if let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: URL(fileURLWithPath: path), options: .atomic)
        }
    }
    
    private func getFilePath(for url: URL) -> String {
        let documentsDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(url.lastPathComponent).path
    }
}
