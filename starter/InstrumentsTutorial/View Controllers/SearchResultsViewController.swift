
import UIKit

class SearchResultsViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  var searchResults: FlickrSearchResults?

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let resultsCount = searchResults?.searchResults.count ?? 0
    title = "\(searchResults?.searchTerm ?? "") (\(resultsCount))"
  }
}

// MARK: - UICollectionViewDataSource
extension SearchResultsViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return searchResults?.searchResults.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)

    guard let resultsCell = cell as? SearchResultsCollectionViewCell else {
      return UICollectionViewCell()
    }

    if let flickrPhoto = searchResults?.searchResults[indexPath.item] {
      resultsCell.flickrPhoto = flickrPhoto
        // MARK: - CHANGE
        
      resultsCell.heartToggleHandler = { [weak self] _ in
        self?.collectionView.reloadItems(at: [indexPath])
      }

        
      ImageCache.shared.loadThumbnail(for: flickrPhoto) { result in
        switch result {
        case .success(let image):
          if resultsCell.flickrPhoto == flickrPhoto {
            if flickrPhoto.isFavorite {
              resultsCell.imageView.image = image
            } else if let filteredImage = image.withTonalFilter {
              resultsCell.imageView.image = filteredImage
            }
          }
        case .failure(let error):
          print("Error: \(error)")
        }
      }
        
//        ImageCache.shared.loadThumbnail(for: flickrPhoto) { result in
//          switch result {
//          case .success(let image):
//            if resultsCell.flickrPhoto == flickrPhoto {
//              if flickrPhoto.isFavorite {
//                resultsCell.imageView.image = image
//              } else {
//                // 1
//                if let cachedImage =
//                  ImageCache.shared.image(forKey: "\(flickrPhoto.id)-filtered") {
//                  resultsCell.imageView.image = cachedImage
//                } else {
//                  // 2
//                  DispatchQueue.global().async {
//                    if let filteredImage = image.withTonalFilter {
//                      ImageCache.shared
//                        .set(filteredImage, forKey: "\(flickrPhoto.id)-filtered")
//
//                      DispatchQueue.main.async {
//                        resultsCell.imageView.image = filteredImage
//                      }
//                    }
//                  }
//                }
//              }
//            }
//          case .failure(let error):
//            print("Error: \(error)")
//          }
//        }

        
    }
    return resultsCell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchResultsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    // 3 images across
    let width = view.bounds.width / 3
    // each image has a ratio of 4:3
    let height = (width / 4) * 3
    return CGSize(width: width, height: height)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
