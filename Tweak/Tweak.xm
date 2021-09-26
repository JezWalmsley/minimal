#import "Tweak.h"


 %group Minimal // For prefs use later

static BBServer* bbServer = nil;

static dispatch_queue_t getBBServerQueue() {

    static dispatch_queue_t queue;
    static dispatch_once_t predicate;

    dispatch_once(&predicate, ^{
    void* handle = dlopen(NULL, RTLD_GLOBAL);
        if (handle) {
            dispatch_queue_t __weak *pointer = (__weak dispatch_queue_t *) dlsym(handle, "__BBServerQueue");
            if (pointer) queue = *pointer;
            dlclose(handle);
        }
    });

    return queue;

}

static void fakeNotification(NSString *title, NSString *sectionID, NSDate *date, NSString *message, bool banner) {
    
	BBBulletin* bulletin = [[%c(BBBulletin) alloc] init];

	bulletin.title = title;
    bulletin.message = message;
    bulletin.sectionID = sectionID;
    bulletin.bulletinID = [[NSProcessInfo processInfo] globallyUniqueString];
    bulletin.recordID = [[NSProcessInfo processInfo] globallyUniqueString];
    bulletin.publisherBulletinID = [NSString stringWithFormat:@"MINIMAL%@", [[NSProcessInfo processInfo] globallyUniqueString]];
    bulletin.date = date;
    bulletin.defaultAction = [%c(BBAction) actionWithLaunchBundleID:sectionID callblock:nil];
    bulletin.clearable = YES;
    bulletin.showsMessagePreview = YES;
	bulletin.expirationDate = date;
    bulletin.publicationDate = date;
    bulletin.lastInterruptDate = date;
	if (banner) {
        if ([bbServer respondsToSelector:@selector(publishBulletin:destinations:)]) {
            dispatch_sync(getBBServerQueue(), ^{
                [bbServer publishBulletin:bulletin destinations:15];
            });
        }
    } else {
        if ([bbServer respondsToSelector:@selector(publishBulletin:destinations:alwaysToLockScreen:)]) {
            dispatch_sync(getBBServerQueue(), ^{
                [bbServer publishBulletin:bulletin destinations:4 alwaysToLockScreen:YES];
            });
        } else if ([bbServer respondsToSelector:@selector(publishBulletin:destinations:)]) {
            dispatch_sync(getBBServerQueue(), ^{
                [bbServer publishBulletin:bulletin destinations:4];
            });
        }
    }
 	
}

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
	NSMutableArray<MinimalButton *> *iconViews = NSMutableArray.array;
	
	for(_UIStatusBar *statusBar in statusBars) {
		if(statusBar) {
			for(id item in statusBar.items.allValues) {
				if([item isKindOfClass:%c(_UIStatusBarTimeItem)]) {
					[timeItems addObject:item];
				}
			}
		}
	}
	
	[UIView animateWithDuration:0.15 animations:^{ // Adding the icon is here HELLO
		if (ringerMuted == YES && vibrateOnSilent == YES) [self triggerHaptics];
		for(_UIStatusBarTimeItem *timeItem in timeItems) for(UILabel *label in @[timeItem.timeView, timeItem.shortTimeView, timeItem.pillTimeView, timeItem.dateView]) label.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1);
	} completion:^(BOOL finished){
		for(_UIStatusBarTimeItem *timeItem in timeItems) for(UILabel *label in @[timeItem.timeView, timeItem.shortTimeView, timeItem.pillTimeView, timeItem.dateView]) label.hidden = YES;
		
		for(_UIStatusBar *statusBar in statusBars) {
			MinimalButton *iconView = [MinimalButton systemButtonWithImage:[notification.notificationViewController.notificationRequest.content.icon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] target:self action:@selector(handleTap:)];
			iconView.presentable = notification;
			iconView.translatesAutoresizingMaskIntoConstraints = NO;
			iconView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1);
			[statusBar addSubview:iconView];
			[iconViews addObject:iconView];
			
			UIView *timeView = nil;
			for(_UIStatusBarTimeItem *timeItem in timeItems) {
				if([statusBar.items.allValues containsObject:timeItem]) {
					if(timeItem.timeView.window) timeView = timeItem.timeView;
					else if(timeItem.shortTimeView.window) timeView = timeItem.shortTimeView;
					else if(timeItem.pillTimeView.window) timeView = timeItem.pillTimeView;
					else if(timeItem.dateView.window) timeView = timeItem.dateView;
					break;
				}
			}
			
			[iconView setContentMode:UIViewContentModeScaleAspectFill];
			[iconView.widthAnchor constraintEqualToConstant:30].active = YES;
			[iconView.heightAnchor constraintEqualToAnchor:iconView.widthAnchor].active = YES;
			
			
			if(timeView) {
				[iconView.centerXAnchor constraintEqualToAnchor:timeView.centerXAnchor].active = YES;
				[iconView.centerYAnchor constraintEqualToAnchor:timeView.centerYAnchor].active = YES;
			}
			
			[UIView animateWithDuration:0.15 animations:^{
				iconView.layer.transform = CATransform3DMakeScale(iconSize, iconSize, iconSize);
	
			}];
		}
	}];

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, [dismissDelay intValue] * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		[UIView animateWithDuration:0.15 animations:^{
			for(MinimalButton *iconView in iconViews) iconView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
		} completion:^(BOOL finished){
			for(MinimalButton *iconView in iconViews) [iconView removeFromSuperview];
			
			for(_UIStatusBarTimeItem *timeItem in timeItems) for(UILabel *label in @[timeItem.timeView, timeItem.shortTimeView, timeItem.pillTimeView, timeItem.dateView]) label.hidden = NO;
			
			[UIView animateWithDuration:0.15 animations:^{
				for(_UIStatusBarTimeItem *timeItem in timeItems) for(UILabel *label in @[timeItem.timeView, timeItem.shortTimeView, timeItem.pillTimeView, timeItem.dateView]) label.layer.transform = CATransform3DMakeScale(1, 1, 1);
			}];
		}];
	});
}

- (void)handleTap:(MinimalButton *)button {
	
    BBBulletin *bulletin = button.presentable.notificationViewController.notificationRequest.bulletin;
	fakeNotification([bulletin title], [bulletin sectionID], [NSDate date], [bulletin message], true);  

}

- (void)triggerHaptics {

	switch(hapticsStrength) {

		case 0:

			AudioServicesPlaySystemSound(1519);
			break;

		case 1:

			AudioServicesPlaySystemSound(1520);
			break;

		case 2:

			AudioServicesPlaySystemSound(1521);
			break;

	}

}

@end

@implementation MinimalButton
@synthesize presentable;
@end

%hook _UIStatusBar 

-(void)viewDidLoad {
	%orig;
	self.userInteractionEnabled = YES;
}

%end

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

%hook BBServer

- (id)initWithQueue:(id)arg1 {

    bbServer = %orig;
    
    return bbServer;

}

- (id)initWithQueue:(id)arg1 dataProviderManager:(id)arg2 syncService:(id)arg3 dismissalSyncCache:(id)arg4 observerListener:(id)arg5 utilitiesListener:(id)arg6 conduitListener:(id)arg7 systemStateListener:(id)arg8 settingsListener:(id)arg9 {
    
    bbServer = %orig;

    return bbServer;

}

- (void)dealloc {

    if (bbServer == self) bbServer = nil;

    %orig;

}

%end

%hook BNContentViewController // Handles the notifications

- (void)_addPresentable:(SBNotificationPresentableViewController *)presentable withTransitioningDelegate:(id)transitioningDelegate incrementingTier:(BOOL)incrementingTier {
	if([presentable isKindOfClass:%c(SBNotificationPresentableViewController)] && ![presentable.notificationViewController.notificationRequest.bulletin.publisherBulletinID hasPrefix:@"MINIMAL"]) {
		[MINController.sharedInstance showNotification:presentable];
	} else %orig;
	
	for(UIView *view in self.viewIfLoaded.subviews) {
		if(view != presentable.viewIfLoaded) [view removeFromSuperview];
	}
}

%end

%hook SBRingerControl 

- (BOOL)isRingerMuted {

    ringerMuted = %orig;

    return ringerMuted;

}


%end

// %hook SBNotificationBannerDestination
// // https://github.com/xyaman/cucu/blob/main/Tweak/Tweak.x#L142
// - (id) _startTimerWithDelay:(unsigned long long)arg1 eventHandler:(id)arg2 {
//     return %orig([dismissDelay intValue], arg2);
// }

// %end


%end

%ctor {
	preferences = [[HBPreferences alloc] initWithIdentifier:@"com.jez.minimalPrefs"];

	[preferences registerBool:&enabled default:NO forKey:@"Enabled"];
	if (!enabled) return;

	[preferences registerInteger:&hapticsStrength default:0 forKey:@"hapticsStrength"];
	[preferences registerDouble:&iconSize default:1 forKey:@"iconSize"];
	[preferences registerBool:&vibrateOnSilent default:YES forKey:@"vibrateOnSilent"];
	[preferences registerObject:&dismissDelay default:@(6) forKey:@"dismissDelay"];

	%init(Minimal)
}