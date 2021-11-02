
import UIKit

let apiKey = "ec9280fb8a22cd361447460a59719cc7"

struct FlickrSearchResults {
    
  let searchTerm: String
  let searchResults: [FlickrPhoto]
    
}

enum FlickrAPI {
  static let defaultSession = URLSession(configuration: .default)
  static var dataTask: URLSessionDataTask?
}

// MARK: - Search
extension FlickrAPI {
  static func searchFlickrForTerm(_ searchTerm: String, completion: @escaping ((Result<FlickrSearchResults, FlickrError>) -> Void)) {
    guard let searchURL = flickrSearchURLForSearchTerm(searchTerm) else {
      return
    }
    dataTask?.cancel()

    let request = URLRequest(url: searchURL)

    dataTask = defaultSession.dataTask(with: request) { data, _, error in
      defer { self.dataTask = nil }

      let result = processSearchRequest(forSearchTerm: searchTerm, data: data, error: error as? FlickrError)

      OperationQueue.main.addOperation {
        completion(result)
      }
    }
    dataTask?.resume()
  }

  private static func processSearchRequest(forSearchTerm searchTerm: String, data: Data?, error: FlickrError?) -> Result<FlickrSearchResults, FlickrError> {
    if let error = error {
      return .failure(error)
    }

    guard let data = data else {
      return .failure(FlickrError.noData)
    }

    guard
      let json = try? JSONSerialization.jsonObject(with: data, options: []),
      let results = json as? [String: Any]
    else {
      return .failure(FlickrError.jsonSerializationFailed(reason: "Failed to convert data to JSON"))
    }

    guard let apiResponse = results["stat"] as? String else {
      return .failure(FlickrError.requestFailed(reason: "No status info in JSON response"))
    }

    let message = (results["message"] as? String) ?? ""

    switch apiResponse {
    case "ok":
      print("Results processed OK.\n" + message)
    case "fail":
      return .failure(FlickrError.requestFailed(reason: "Request failed.\n" + message))
    default:
      return .failure(FlickrError.requestFailed(reason: "Unknown API response.\n" + message))
    }

    guard
      let photosContainer = results["photos"] as? [String: Any],
      let photosReceived = photosContainer["photo"] as? [[String: Any]],
      let photosData = jsonToString(photosReceived)?.data(using: .utf8),
      let flickrPhotos = try? JSONDecoder().decode([FlickrPhoto].self, from: photosData)
    else {
      return .failure(FlickrError.processingPhotosFailed(reason: "Could not get photos from JSON payload"))
    }
    return .success(FlickrSearchResults(searchTerm: searchTerm, searchResults: flickrPhotos))
  }

  private static func jsonToString(_ json: Any) -> String? {
    guard
      let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
      let converted = String(data: data, encoding: .utf8)
    else {
      return nil
    }
    return converted
  }

  private static func flickrSearchURLForSearchTerm(_ searchTerm: String) -> URL? {
    if let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
      let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(escapedTerm)&per_page=60&format=json&nojsoncallback=1"
      return URL(string: URLString)
    }
    return nil
  }
}

// MARK: - Image Loading
extension FlickrAPI {
  typealias FetchImageResult = Result<UIImage, FlickrError>
  typealias FetchImageCompletion = (FetchImageResult) -> Void

  static func imageURL(for photo: FlickrPhoto, size: String = "m") -> URL? {
    let urlString = "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_\(size).jpg"
    return URL(string: urlString)
  }

  static func loadLargeImage(for photo: FlickrPhoto, completion: @escaping FetchImageCompletion) {
    loadImage(for: photo, withSize: "b", completion)
  }

  static func processImageRequest(_ data: Data?, _ error: FlickrError?) -> FetchImageResult {
    guard
      let imageData = data,
      let image = UIImage(data: imageData)
    else {
      if let error = error, data == nil {
        return .failure(error)
      } else {
        return .failure(FlickrError.imageCreationFailed)
      }
    }
    return Result.success(image)
  }

  static func loadImage(for photo: FlickrPhoto, withSize size: String, _ completion: @escaping FetchImageCompletion) {
    let session = URLSession.shared

    guard let url = imageURL(for: photo, size: size) else { return }

    let dataTask = session.dataTask(with: url) { data, _, error in
      let result = self.processImageRequest(data, error as? FlickrError)

      OperationQueue.main.addOperation {
        completion(result)
      }
    }
    dataTask.resume()
  }
}

// MARK: - Error Definitions
enum FlickrError: Error {
  case noData
  case jsonSerializationFailed(reason: String)
  case requestFailed(reason: String)
  case processingPhotosFailed(reason: String)
  case imageCreationFailed
}

extension FlickrError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .noData:
      return "No data returned with response"
    case .jsonSerializationFailed(let reason):
      return reason
    case .requestFailed(let reason):
      return reason
    case .processingPhotosFailed(let reason):
      return reason
    case .imageCreationFailed:
      return "Could not create image from returned data"
    }
  }
}
