#import "Tweak.h"

// %group Minimal // For prefs use later

UIView *timeView = nil;

@implementation MINController
@synthesize statusBar = _statusBar;
@synthesize appStatusBar = _appStatusBar;

+ (instancetype)sharedInstance {
	static MINController *sharedInstance = nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		sharedInstance = [[MINController alloc] init]; // Only runs this once in a sharedInstance
	});
	
	return sharedInstance;
}

- (NSArray<_UIStatusBar *> *)statusBars {
	NSMutableArray *statusBars = NSMutableArray.array;
	
	if(self.statusBar) [statusBars addObject:self.statusBar];
	if(self.appStatusBar) [statusBars addObject:self.appStatusBar];
	
	return statusBars;
}

- (void)showNotification:(SBNotificationPresentableViewController *)notification {
	NSArray<_UIStatusBar *> *statusBars = self.statusBars;
	NSMutableArray<_UIStatusBarTimeItem *> *timeItems = NSMutableArray.array;
	NSMutableArray<UIImageView *> *iconViews = NSMutableArray.array;
	
	for(_UIStatusBar *statusBar in statusBars) {
		if(statusBar) {
			for(id item in statusBar.items.allValues) {
				if([item isKindOfClass:%c(_UIStatusBarTimeItem)]) {
					[timeItems addObject:item];
				}
			}
		}
	}
	
	[UIView animateWithDuration:0.15 animations:^{
		for(_UIStatusBarTimeItem *timeItem in timeItems) for(UILabel *label in @[timeItem.timeView, timeItem.shortTimeView, timeItem.pillTimeView, timeItem.dateView]) label.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1);
	} completion:^(BOOL finished){
		for(_UIStatusBarTimeItem *timeItem in timeItems) for(UILabel *label in @[timeItem.timeView, timeItem.shortTimeView, timeItem.pillTimeView, timeItem.dateView]) label.hidden = YES;
		
		for(_UIStatusBar *statusBar in statusBars) {
			UIImageView *iconView = [[UIImageView alloc] initWithImage:notification.notificationViewController.notificationRequest.content.icon];
			UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
			iconView.translatesAutoresizingMaskIntoConstraints = NO;
			iconView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1);
			[self addGestureRecognizer:recognizer];
			[statusBar addSubview:iconView];
			[iconViews addObject:iconView];
			
			
			for(_UIStatusBarTimeItem *timeItem in timeItems) {
				if([statusBar.items.allValues containsObject:timeItem]) {
					if(timeItem.timeView.window) timeView = timeItem.timeView;
					else if(timeItem.shortTimeView.window) timeView = timeItem.shortTimeView;
					else if(timeItem.pillTimeView.window) timeView = timeItem.pillTimeView;
					else if(timeItem.dateView.window) timeView = timeItem.dateView;
					break;
				}
			}
			
			[iconView.widthAnchor constraintEqualToConstant:30].active = YES;
			[iconView.heightAnchor constraintEqualToAnchor:iconView.widthAnchor].active = YES;
			
			if(timeView) {
				[iconView.centerXAnchor constraintEqualToAnchor:timeView.centerXAnchor].active = YES;
				[iconView.centerYAnchor constraintEqualToAnchor:timeView.centerYAnchor].active = YES;
			}
			
			[UIView animateWithDuration:0.15 animations:^{
				iconView.layer.transform = CATransform3DMakeScale(1, 1, 1);
			}];
		}
	}];
	

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		[UIView animateWithDuration:0.15 animations:^{
			for(UIImageView *iconView in iconViews) iconView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
		} completion:^(BOOL finished){
			for(UIImageView *iconView in iconViews) [iconView removeFromSuperview];
			
			for(_UIStatusBarTimeItem *timeItem in timeItems) for(UILabel *label in @[timeItem.timeView, timeItem.shortTimeView, timeItem.pillTimeView, timeItem.dateView]) label.hidden = NO;
			
			[UIView animateWithDuration:0.15 animations:^{
				for(_UIStatusBarTimeItem *timeItem in timeItems) for(UILabel *label in @[timeItem.timeView, timeItem.shortTimeView, timeItem.pillTimeView, timeItem.dateView]) label.layer.transform = CATransform3DMakeScale(1, 1, 1);
			}];
		}];
	});
}
@end

%hook SpringBoard
- (void)_createStatusBarWithRequestedStyle:(NSInteger)style orientation:(NSInteger)orientation hidden:(BOOL)hidden {
	%orig;
	
	MINController.sharedInstance.statusBar = MSHookIvar<UIStatusBar_Modern *>(self, "_statusBar").statusBar;
}
%end

%hook SBMainDisplaySceneLayoutStatusBarView

- (id)createStatusBarWithFrame:(CGRect)frame interfaceOrientation:(NSInteger)interfaceOrientation reason:(id)reason {
	UIStatusBar_Modern *result = %orig;
	
	MINController.sharedInstance.appStatusBar = result.statusBar;

	return result;
}
%end

%hook BNContentViewController
//Use this to get notifications one at a time
/*- (void)presentPresentable:(SBNotificationPresentableViewController *)presentable withOptions:(NSUInteger)options userInfo:(id)userInfo {
	if([presentable isKindOfClass:%c(SBNotificationPresentableViewController)]) [MINController.sharedInstance showNotification:presentable];
	else %orig;
}*/

	%new
	- (void)handleTap:(UITapGestureRecognizer *)recognizer {
		if(timeView != nil) {
			[self loadView];
		}
} 
	

//Use this to get all notifications simultaniously
- (void)_addPresentable:(SBNotificationPresentableViewController *)presentable withTransitioningDelegate:(id)transitioningDelegate incrementingTier:(BOOL)incrementingTier {
	if([presentable isKindOfClass:%c(SBNotificationPresentableViewController)]) [MINController.sharedInstance showNotification:presentable];
	else %orig;
}
%end

// %end