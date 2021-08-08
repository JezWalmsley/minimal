#import <UIKit/UIKit.h>

@interface MTPlatterView : UIView
@end

@interface MTTitledPlatterView : MTPlatterView
@end

@interface NCNotificationShortLookView : MTTitledPlatterView
@property(nonatomic, copy)NSArray* icons;
@property(nonatomic, copy)NSString* title;
@property(nonatomic, copy)NSString* primaryText;
@property(nonatomic, copy)NSString* secondaryText;
@property(nonatomic, retain)UIView* minimalView;
@property(nonatomic, retain)UIBlurEffect* minimalBlur;
@property(nonatomic, retain)UIVisualEffectView* minimalBlurView;
@property(nonatomic, strong)UIImageView* minimalIconView;
@property(nonatomic, retain)UILabel* minimalTitleLabel;
@end

@interface UIView (Minimal)
- (id)_viewControllerForAncestor;
@end

@interface _UIStatusBarStringView
-(void)setText:(id)arg1 ;
@end

@interface _UIStatusBarTimeItem
-(void)setShortTimeView:(_UIStatusBarStringView *)arg1 ;
-(void)_create_timeView;
@end
