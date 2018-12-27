import UIKit

extension UIViewController {
    /*
    var alertController: UIAlertController? {
        guard let alert = UIApplication.topViewController() as? UIAlertController else { return nil }
        return alert
    }
 */
    
    func addChildViewController(_ child: UIViewController, to view: UIView) {
        child.view.frame = view.bounds
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
}
