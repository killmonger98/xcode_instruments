
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    return true
    
  }
    
}

extension UINavigationController {
    
  open override var preferredStatusBarStyle: UIStatusBarStyle {
    
    return .lightContent
    
  }
    
}
