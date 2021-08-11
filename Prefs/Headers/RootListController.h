#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import "NSTask.h"
#import <UserNotifications/UserNotifications.h>

@interface AppearanceSettings : HBAppearanceSettings
@end

@interface RootListController : HBRootListController {
    UITableView * _table;
}

@property (nonatomic, retain) UIBarButtonItem *respringButton;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIImageView *headerImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *titleSublabel;
@property (nonatomic, retain) UIImageView *iconView;
@property (nonatomic, retain) UITapGestureRecognizer *tap;

-(void)respring;
-(void)respringUtil;
-(void)enableDebugMode:(UITapGestureRecognizer *)recognizer;
-(void)contactSupport;
-(void)reloadForDarkMode:(NSNotification*)note;

@end