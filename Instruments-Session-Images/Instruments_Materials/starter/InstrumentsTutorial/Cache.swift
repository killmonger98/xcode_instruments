
import UIKit

class ImageCache {
  static let shared = ImageCache()
  var images: [String: UIImage] = [:]

//  func loadThumbnail(for photo: FlickrPhoto, completion: @escaping FlickrAPI.FetchImageCompletion) {
//    FlickrAPI.loadImage(for: photo, withSize: "m") { result in
//      completion(result)
//    }
//  }
    
    init() {
        
      NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: nil, queue: .main) { [weak self] _ in
          self?.images.removeAll(keepingCapacity: false)
      }
        
    }

    
    func loadThumbnail(for photo: FlickrPhoto, completion: @escaping FlickrAPI.FetchImageCompletion) {
      if let image = ImageCache.shared.image(forKey: photo.id) {
        completion(Result.success(image))
      } else {
        FlickrAPI.loadImage(for: photo, withSize: "m") { result in
          if case .success(let image) = result {
            ImageCache.shared.set(image, forKey: photo.id)
          }
          completion(result)
        }
      }
    }
    
}

// MARK: - Custom Accessors
extension ImageCache {
  func set(_ image: UIImage, forKey key: String) {
    images[key] = image
  }

  func image(forKey key: String) -> UIImage? {
    return images[key]
  }
}
