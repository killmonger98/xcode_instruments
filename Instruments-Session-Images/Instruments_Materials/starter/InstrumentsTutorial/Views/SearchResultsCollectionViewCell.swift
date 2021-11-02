
import UIKit

class SearchResultsCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var heartButton: UIButton!
  @IBOutlet weak var imageView: UIImageView!

  // swiftlint:disable:next implicitly_unwrapped_optional
  var flickrPhoto: FlickrPhoto! {
    didSet {
      if flickrPhoto.isFavorite {
        heartButton.tintColor = UIColor(red: 1, green: 0, blue: 0.517, alpha: 1)
      } else {
        heartButton.tintColor = .white
      }
    }
  }

  var heartToggleHandler: ((_ isFavourite: Bool) -> Void)?

  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
  }
}

// MARK: - IBActions
extension SearchResultsCollectionViewCell {
  @IBAction func heartTapped(_ sender: AnyObject) {
    flickrPhoto.isFavorite.toggle()
    heartToggleHandler?(flickrPhoto.isFavorite)
  }
}
