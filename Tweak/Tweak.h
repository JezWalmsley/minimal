#import <UIKit/UIKit.h>
#import <dlfcn.h>
#import <Cephei/HBPreferences.h>
#import <SpringBoard/SpringBoard.h>

HBPreferences* preferences = nil;
BOOL enabled = NO;

@interface SBBannerManager : NSObject
@property UIWindow *bannerWindow;
-(void)dismissAllBannersAnimated:(BOOL)arg1 reason:(id)arg2 ;
@end

@interface SpringBoard ()
@property (nonatomic, assign, readonly) SBBannerManager *bannerManager;
@end

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

@interface BBAction : NSObject
+ (id)actionWithLaunchBundleID:(id)arg1 callblock:(id)arg2;
@end

@interface BBBulletin : NSObject
@property(nonatomic, copy)NSString* sectionID;
@property(nonatomic, copy)NSString* header;
@property(nonatomic, copy)NSString* section; 
@property(nonatomic, copy)NSString* recordID;
@property(nonatomic, copy)NSString* publisherBulletinID;
@property(nonatomic, copy)NSString* title;
@property(nonatomic, copy)NSString* message;
@property(nonatomic, retain)NSDate* date;
@property(assign, nonatomic)BOOL clearable;
@property(nonatomic)BOOL showsMessagePreview;
@property(nonatomic, copy)BBAction* defaultAction;
@property(nonatomic, copy)NSString* bulletinID;
@property(nonatomic, retain)NSDate* lastInterruptDate;
@property(nonatomic, retain)NSDate* publicationDate;
@property(nonatomic, copy)NSString* threadID;
@end

@interface NCNotificationContent : NSObject
@property (nonatomic, assign, readonly) UIImage *icon;
@end

@interface NCNotificationRequest : NSObject
@property (nonatomic,readonly) BBBulletin *bulletin;
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

- (void)showNotification:(SBNotificationPresentableViewController *)notification;
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

@interface MinimalButton : UIButton
@property (nonatomic, strong, readwrite) SBNotificationPresentableViewController *presentable;
@end

@interface BBServer : NSObject
- (void)publishBulletin:(BBBulletin *)arg1 destinations:(NSUInteger)arg2 alwaysToLockScreen:(BOOL)arg3;
- (void)publishBulletin:(id)arg1 destinations:(unsigned long long)arg2;
- (void)_clearBulletinIDs:(id)arg1 forSectionID:(id)arg2 shouldSync:(BOOL)arg3;
@end

@interface BBObserver : NSObject
@end

@interface NCBulletinNotificationSource : NSObject
- (BBObserver *)observer;
@end

@interface SBNCNotificationDispatcher : NSObject
- (NCBulletinNotificationSource *)notificationSource;
@end

@interface SBNotificationBannerDestination : NSObject
-(void)_cancelDismissTimer;
-(void)_cancelReplaceAndDismissTimers;
-(void)_performCancelAction;
@end

@interface NCNotificationDispatcher : NSObject
-(void)postNotificationWithRequest:(id)arg1 ;
@end

