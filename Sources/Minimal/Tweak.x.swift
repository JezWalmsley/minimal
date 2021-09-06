import Orion
import UIKit
import MinimalC

var wasAdded = false

class NCNotificationDispatcherHook : ClassHook<NCNotificationDispatcher> {
    
    func postNotificationWithRequest(_ arg1: NCNotificationRequest?) {
        orig.postNotificationWithRequest(arg1)
        MinimalController.sharedInstance.addNotification(arg1)
    }
    
    func withdrawNotificationWithRequest(_ arg1: NCNotificationRequest?) {
        orig.withdrawNotificationWithRequest(arg1)
        MinimalController.sharedInstance.removeNotification(arg1)
    }
}

class StatusBarStringViewHook: ClassHook<UILabel> {
    @Property(.nonatomic) var iAmTime = false
    @Property(.nonatomic, .retain) var minimalView : MinimalView? = nil

    static let targetName = "_UIStatusBarStringView"
    
    func setText(_ text: String) {
        orig.setText(text)
        iAmTime = text.contains(":")
        if(iAmTime) {
            
            if(minimalView == nil) {
                minimalView = MinimalView()
                MinimalController.sharedInstance.views.append(minimalView!)
            }
            
            target.isHidden = true
        
        }
    }

    func setFrame(_ rect: CGRect) {
        orig.setFrame(rect)

        if(iAmTime) {
            minimalView?.frame = target.frame
        }
    }
    
    func layoutSubviews() {
        orig.layoutSubviews()
        
        if(iAmTime && minimalView != nil) {
            minimalView?.frame = target.frame
        }
    }
    
    func didMoveToSuperview() {
        orig.didMoveToSuperview()
        
        if(iAmTime && minimalView != nil) {
            target.superview?.addSubview(minimalView!)
            minimalView?.frame = target.frame
        }
    }
    
    func didMoveToWindow() {
        orig.didMoveToWindow()
        
        if(iAmTime && minimalView != nil) {
            target.superview?.addSubview(minimalView!)
            minimalView?.frame = target.frame
        }
    }
}
