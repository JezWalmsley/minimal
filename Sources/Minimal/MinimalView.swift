import UIKit
import MinimalC

class MinimalView: UIView {
    
    var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        stackView = UIStackView()
        self.addSubview(stackView)
        
        stackView.spacing = 1
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.axis = .horizontal
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        update()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        for subview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(subview)
            subview.isHidden = true
        }
        
        
        
        let maxIcons = Int(floor(self.frame.width / (10 + stackView.spacing)))
        let iconsCount = MinimalController.sharedInstance.bundles.count > maxIcons ? maxIcons : MinimalController.sharedInstance.bundles.count
        
        if (MinimalController.sharedInstance.bundles.isEmpty || maxIcons == 0) {
            return
        }
                
//        for bundle in MinimalController.sharedInstance.bundles {
//            let iconView = UIImageView(image: bundle.icon)
//            stackView.addArrangedSubview(iconView)
//            iconView.contentMode = .scaleAspectFit
//
//            iconView.heightAnchor.constraint(equalToConstant: 10).isActive = true
//            iconView.widthAnchor.constraint(equalToConstant: 10).isActive = true
//        }
        
        for i in 0...iconsCount - 1 {
            let bundle = MinimalController.sharedInstance.bundles[i]
            let iconView = UIImageView(image: bundle.icon)
            stackView.addArrangedSubview(iconView)
            iconView.contentMode = .scaleAspectFit
            
            iconView.heightAnchor.constraint(equalToConstant: 10).isActive = true
            iconView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        }

    }
}

class NotificationView : UIImageView {
    
//    override var intrinsicContentSize: CGSize {
//        return CGSize(width: 5, height: 5)
//    }
}
