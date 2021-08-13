#import <UIKit/UIKit.h>

@interface _UIStatusBar : UIView
@property (nonatomic, strong, readwrite) NSMutableDictionary *items;
@end

@interface UIStatusBar_Modern : UIView
@property (nonatomic, strong, readwrite) _UIStatusBar *statusBar;
@end

@interface _UIStatusBarTimeItem : NSObject
@property (nonatomic, strong, readwrite) UILabel *timeView;
@property (nonatomic, strong, readwrite) UILabel *shortTimeView;
@property (nonatomic, strong, readwrite) UILabel *pillTimeView;
@property (nonatomic, strong, readwrite) UILabel *dateView;
@end

@interface NCNotificationContent : NSObject
@property (nonatomic, assign, readonly) UIImage *icon;
@end

@interface NCNotificationRequest : NSObject
@property (nonatomic, assign, readonly) NCNotificationContent *content;
@end

@interface NCNotificationViewController : UIViewController
@property (nonatomic, strong, readwrite) NCNotificationRequest *notificationRequest;
@end

@interface SBNotificationPresentableViewController : UIViewController
@property (nonatomic, assign, readonly) NCNotificationViewController *notificationViewController; 
@end

@interface MINController : NSObject {}
@property (nonatomic, readonly, class) MINController *sharedInstance;

@property (nonatomic, strong, readwrite) _UIStatusBar *statusBar;
@property (nonatomic, strong, readwrite) _UIStatusBar *appStatusBar;
@property (nonatomic, readonly) NSArray<_UIStatusBar *> *statusBars;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@interface BNContentViewController : UIViewController
-(void)loadView;
- (void)handleTap:(UITapGestureRecognizer *)recognizer;
+(void)initialize;
-(void)_addPresentable:(id)arg1 withTransitioningDelegate:(id)arg2 incrementingTier:(BOOL)arg3; 
-(BOOL)_canShowWhileLocked;
@end

@interface _UIStatusBarForegroundView : UIView
@property(nonatomic, retain)UIView* statusBarForegroundView;
@end