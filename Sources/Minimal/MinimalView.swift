import UIKit
import MinimalC

class MinimalView: UIView {
    
    var stackView: UIStackView = UIStackView()
    var imagesViewPool: [UIImageView]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(stackView)

        
        // Initialize UIImageViews
        imagesViewPool = (0...5).map { _ in UIImageView() }
        imagesViewPool.forEach({
            stackView.addArrangedSubview($0)
            $0.heightAnchor.constraint(equalToConstant: 10).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 10).isActive = true
            $0.contentMode = .scaleAspectFit
        })
        
        stackView.spacing = 0
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
        imagesViewPool.forEach({$0.isHidden = true})
        
        let maxIcons = Int(floor(self.frame.width / (10 + stackView.spacing)))
        let iconsCount = MinimalController.sharedInstance.bundles.count > maxIcons ? maxIcons : MinimalController.sharedInstance.bundles.count
        
        if (MinimalController.sharedInstance.bundles.isEmpty || maxIcons == 0) {
            return
        }
                
        // TODO: Improve pool
        for i in 0...iconsCount - 1 {
            let bundle = MinimalController.sharedInstance.bundles[i]
            let imageView = imagesViewPool[i]
            imageView.image = bundle.icon
            imageView.isHidden = false
        }

    }
}

class NotificationView : UIImageView {
    
//    override var intrinsicContentSize: CGSize {
//        return CGSize(width: 5, height: 5)
//    }
}
