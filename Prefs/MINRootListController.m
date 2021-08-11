#include "Headers/RootListController.h"

@implementation RootListController

- (instancetype)init {
    self = [super init];

    if (self) {
        
        AppearanceSettings *appearanceSettings = [[AppearanceSettings alloc] init];
        self.hb_appearanceSettings = appearanceSettings;

        if (@available(iOS 13.0, *)) {
            if( self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){ //detect whether the device is using dark or light mode.

                [self.navigationController.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
            
            } else {

                [self.navigationController.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];

            }
        } else { //iOS 12 or lower

            [self.navigationController.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];

        }

        self.respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring" 
                                    style:UIBarButtonItemStylePlain
                                    target:self 
                                    action:@selector(respring)];

        if (@available(iOS 13.0, *)) {
            if( self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){ //detect whether the device is using dark or light mode.

                self.respringButton.tintColor = [UIColor whiteColor];
            
            } else {

                self.respringButton.tintColor = [UIColor blackColor];

            }
        } else { //iOS 12 or lower

            self.respringButton.tintColor = [UIColor blackColor];

        }

        self.navigationItem.rightBarButtonItem = self.respringButton;

        self.navigationItem.titleView = [UIView new];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,10,10)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.text = @"Minimal";

        if (@available(iOS 13.0, *)) {

            if( self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){ //detect whether the device is using dark or light mode.

                self.titleLabel.textColor = [UIColor whiteColor];
            
            } else {

                self.titleLabel.textColor = [UIColor blackColor];

            }

        } else { //iOS 12 or lower

            self.titleLabel.textColor = [UIColor blackColor];

        }

        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.navigationItem.titleView addSubview:self.titleLabel];

        self.titleSublabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,10,10)];
        self.titleSublabel.font = [UIFont systemFontOfSize:12];
        self.titleSublabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleSublabel.text = @"Version 1.0-beta";

        if (@available(iOS 13.0, *)) {
            
            if( self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){ //detect whether the device is using dark or light mode.

                self.titleSublabel.textColor = [UIColor whiteColor];
            
            } else {

                self.titleSublabel.textColor = [UIColor blackColor];

            }

        } else { //iOS 12 or lower

            self.titleSublabel.textColor = [UIColor blackColor];

        }


        self.titleSublabel.textAlignment = NSTextAlignmentCenter;
        [self.navigationItem.titleView addSubview:self.titleSublabel];

        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,10,10)];
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/MinimalPrefs.bundle/icon.png"];
        self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
        self.iconView.alpha = 0.0;
        [self.navigationItem.titleView addSubview:self.iconView];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.titleLabel.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor constant:-15],
            [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
            [self.iconView.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
            [self.iconView.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.iconView.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.iconView.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
            [self.titleSublabel.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor constant:15],
            [self.titleSublabel.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.titleSublabel.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.titleSublabel.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
        ]];
    }

    return self;
}

-(NSArray *)specifiers {
	if (_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;

    if (@available(iOS 13.0, *)) {
        if( self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){ //detect whether the device is using dark or light mode.

            self.headerImageView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/MinimalPrefs.bundle/Banner-dark.png"];

        } else {

            self.headerImageView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/MinimalPrefs.bundle/Banner-light.png"];

        }
    } else { //iOS 12 or lower

        self.headerImageView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/MinimalPrefs.bundle/Banner-light.png"];

    }
    
    
    self.headerImageView.translatesAutoresizingMaskIntoConstraints = NO;

    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enableDebugMode:)];

    [self.headerImageView addGestureRecognizer:self.tap];
    self.headerImageView.userInteractionEnabled = YES;

    [self.headerView addSubview:self.headerImageView];
    [NSLayoutConstraint activateConstraints:@[
        [self.headerImageView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
        [self.headerImageView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        [self.headerImageView.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
        [self.headerImageView.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
    ]];

    _table.tableHeaderView = self.headerView;
    [_table.tableHeaderView addGestureRecognizer:self.tap];
    _table.tableHeaderView.userInteractionEnabled = YES;

    [[NSNotificationCenter defaultCenter]addObserver:self
                                   selector:@selector(reloadForDarkMode:)
                                   name:UIApplicationDidBecomeActiveNotification
                                   object:nil];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.tableHeaderView = self.headerView;
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    CGRect frame = self.table.bounds;
    frame.origin.y = -frame.size.height;

    //self.navigationController.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.64 green:0.67 blue:1.00 alpha:1.0];
    [self.navigationController.navigationController.navigationBar setShadowImage: [UIImage new]];

    if (@available(iOS 13.0, *)) {
            
        if( self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){ //detect whether the device is using dark or light mode.

            self.navigationController.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        
        } else {

            self.navigationController.navigationController.navigationBar.barTintColor = [UIColor blackColor];

        }

    } else { //iOS 12 or lower

        self.navigationController.navigationController.navigationBar.barTintColor = [UIColor blackColor];

    }

    self.navigationController.navigationController.navigationBar.translucent = NO;

}

- (void)reloadForDarkMode:(NSNotification*)note {
    [UINavigationBar appearance];
    [self.headerView setNeedsDisplay];

    if (@available(iOS 13.0, *)) {
        if( self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){ //detect whether the device is usign dark or light mode.

            self.headerImageView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/MinimalPrefs.bundle/Banner-dark.png"];

        } else {

            self.headerImageView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/MinimalPrefs.bundle/Banner-light.png"];

        }
    } else { //iOS 12 or lower

        self.headerImageView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/MinimalPrefs.bundle/Banner-light.png"];

    }

    if (@available(iOS 13.0, *)) {
        if( self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){ //detect whether the device is using dark or light mode.

            self.respringButton.tintColor = [UIColor whiteColor];
        
        } else {

            self.respringButton.tintColor = [UIColor blackColor];

        }
    } else { //iOS 12 or lower

        self.respringButton.tintColor = [UIColor blackColor];

    }

    if (@available(iOS 13.0, *)) {

        if( self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){ //detect whether the device is using dark or light mode.

            self.titleLabel.textColor = [UIColor whiteColor];
        
        } else {

            self.titleLabel.textColor = [UIColor blackColor];

        }

    } else { //iOS 12 or lower

        self.titleLabel.textColor = [UIColor blackColor];

    }

    if (@available(iOS 13.0, *)) {

        if( self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){ //detect whether the device is using dark or light mode.

            self.titleSublabel.textColor = [UIColor whiteColor];
        
        } else {

            self.titleSublabel.textColor = [UIColor blackColor];

        }

    } else { //iOS 12 or lower

        self.titleSublabel.textColor = [UIColor blackColor];

    }

    if (@available(iOS 13.0, *)) {
            
        if( self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){ //detect whether the device is using dark or light mode.

            self.navigationController.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        
        } else {

            self.navigationController.navigationController.navigationBar.barTintColor = [UIColor blackColor];

        }

    } else { //iOS 12 or lower

        self.navigationController.navigationController.navigationBar.barTintColor = [UIColor blackColor];

    }

    self.navigationController.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (@available(iOS 13.0, *)) {
        if( self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){ //detect whether the device is using dark or light mode.

            [self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
        
        } else {

            [self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

        }
    } else { //iOS 12 or lower

        [self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self        
                                 name:UIApplicationDidBecomeActiveNotification 
                                 object:nil];

    if (@available(iOS 13.0, *)) {
        if( self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){ //detect whether the device is using dark or light mode.

            [self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
        
        } else {

            [self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

        }
    } else { //iOS 12 or lower

        [self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY > 200) {
        [UIView animateWithDuration:0.2 animations:^{
            self.iconView.alpha = 1.0;
            self.titleLabel.alpha = 0.0;
            self.titleSublabel.alpha = 0.0;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.iconView.alpha = 0.0;
            self.titleLabel.alpha = 1.0;
            self.titleSublabel.alpha = 1.0;
        }];
    }
    
    if (offsetY > 0) offsetY = 0;
    self.headerImageView.frame = CGRectMake(0, offsetY, self.headerView.frame.size.width, 200 - offsetY);
}

-(void)respring {
	UIAlertController *respring = [UIAlertController alertControllerWithTitle:@"Minimal"
													 message:@"Do you really want to respring?"
													 preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
			[self respringUtil];
	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
	[respring addAction:confirmAction];
	[respring addAction:cancelAction];
	[self presentViewController:respring animated:YES completion:nil];

}

-(void)respringUtil {
	NSTask *t = [[NSTask alloc] init];
    [t setLaunchPath:@"/usr/bin/killall"];
    [t setArguments:[NSArray arrayWithObjects:@"backboardd", nil]];
    [t launch];
}

- (void)enableDebugMode:(UITapGestureRecognizer *)recognizer {
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];

    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Minimal";
    content.body = @"Debug mode enabled!";
    content.badge = 0;

    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];

    UNNotificationRequest *requesta = [UNNotificationRequest requestWithIdentifier:@"me.jez.minimal.notify" content:content trigger:trigger];

    [UNUserNotificationCenter.currentNotificationCenter addNotificationRequest:requesta withCompletionHandler:nil];
}

- (void)contactSupport {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:walmsleyj2006@gmail.com?subject=%5BSUPPORT%5D%20Minimal%20v1.0&body=**Describe%20the%20bug**%0D%0AA%20clear%20and%20concise%20description%20of%20what%20the%20bug%20is.%0D%0A%0D%0A**To%20Reproduce**%0D%0ASteps%20to%20reproduce%20the%20behavior%3A%0D%0A1.%20Go%20to%20'...'%0D%0A2.%20Click%20on%20'....'%0D%0A3.%20Scroll%20down%20to%20'....'%0D%0A4.%20See%20error%0D%0A%0D%0A**Expected%20behavior**%0D%0AA%20clear%20and%20concise%20description%20of%20what%20you%20expected%20to%20happen.%0D%0A%0D%0A**Screenshots**%0D%0AIf%20applicable%2C%20add%20screenshots%20to%20help%20explain%20your%20problem.%0D%0A%0D%0A**Device%20(please%20complete%20the%20following%20information)%3A**%0D%0A-%20Model%3A%20%5Be.g.%20device%206%5D%0D%0A-%20iOS%20Version%3A%20%5Be.g.%2013.3%5D%0D%0A%0D%0A**Additional%20context**%0D%0AAdd%20any%20other%20context%20about%20the%20problem%20here.%0D%0A%0D%0A**%20--%20DO%20NOT%20WRITE%20BELOW%20THIS%20LINE%20--%20**%0D%0ANOTE%3A%20This%20email%20will%20be%20automatically%20generated%20into%20a%20GitHub%20issue%20by%20our%20email%20bot.%0D%0AAny%20interaction%2C%20including%20mentions%20and%20related%20pull-requests%2C%20will%20be%20notified%20through%20email.%0D%0AAny%20reply%20to%20this%20email%20will%20be%20generated%20into%20comments."] options:@{} completionHandler:nil];
}

@end