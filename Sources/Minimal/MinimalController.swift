import UIKit
import MinimalC

class MinimalController {
    
    var views: [MinimalView]
    var bundles: [Bundle] = []
    
    static let sharedInstance: MinimalController = MinimalController()
    
    init() {
        views = []
    }
        
    func addNotification(_ notif: NCNotificationRequest?) {
        
        guard notif!.content.icon != nil else {
            return
        }
        
        if var bundle = bundles.first(where: {$0.id == notif!.bulletin.sectionID}) {
            bundle.count += 1
            bundle.lastUpdate = notif!.timestamp
        
        } else {
            let bundle = Bundle(icon: notif!.content.icon, id: notif!.bulletin.sectionID)
            bundles.append(bundle)
        }

        
        // Sort by notification count
        bundles.sort(by: {$0.count > $1.count })
        
        for minView in views {
            minView.update()
        }
                
    }
    
    func removeNotification(_ notif: NCNotificationRequest?) {
            
        if let index = bundles.firstIndex(where: {$0.id == notif!.bulletin.sectionID}) {
            bundles.remove(at: index)
            
            for minView in views {
                minView.update()
            }
        }
    }
}
