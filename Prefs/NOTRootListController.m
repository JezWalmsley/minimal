#import <Foundation/Foundation.h>
#import "NOTRootListController.h"

@implementation NOTRootListController

- (instancetype) init {
    self = [super init];

    if (self) {
        HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
        appearanceSettings.tintColor = [UIColor colorWithRed:(36.0/255.0) green:(132.0/255.0) blue:(128.0/255.0) alpha:1.0];
        appearanceSettings.tableViewCellSeparatorColor = [UIColor colorWithWhite:0.0 alpha:0.0];

        self.hb_appearanceSettings = appearanceSettings;
    }

    return self;
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}


-(void)viewDidLoad {

	[super viewDidLoad];
	// add respring option
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStyleDone target:self action:@selector(respring:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:(36.0/255.0) green:(132.0/255.0) blue:(128.0/255.0) alpha:1.0];;

	UIImage *banner = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/minimalPrefs.bundle/Assets/Banner.png"];
	self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,UIScreen.mainScreen.bounds.size.width,UIScreen.mainScreen.bounds.size.width * banner.size.height / banner.size.width)];
	self.headerImageView = [UIImageView new];
	self.headerImageView.image = banner;
	self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
	self.headerImageView.translatesAutoresizingMaskIntoConstraints = NO;

	[self.headerView addSubview:self.headerImageView];

	[NSLayoutConstraint activateConstraints:@[

		[self.headerImageView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
		[self.headerImageView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
		[self.headerImageView.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],   
		[self.headerImageView.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],

	]];

}

- (void)viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];

	CGRect frame = self.table.bounds;
	frame.origin.y = -frame.size.height;

	[self.navigationController.navigationController.navigationBar setShadowImage: [UIImage new]];
	self.navigationController.navigationController.navigationBar.tintColor = UIColor.whiteColor;

}

 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	tableView.tableHeaderView = self.headerView;
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

	CGFloat offsetY = scrollView.contentOffset.y;

	if (offsetY > 150) {
		[UIView animateWithDuration:0.2 animations:^{
			self.iconView.alpha = 1.0;
			self.titleLabel.alpha = 0.0;
		}];
	} else {
		[UIView animateWithDuration:0.2 animations:^{
			self.iconView.alpha = 0.0;
			self.titleLabel.alpha = 1.0;
		}];
	}

	if (offsetY > 0) offsetY = 0;
	self.headerImageView.frame = CGRectMake(0, offsetY, self.headerView.frame.size.width, 200 - offsetY);
}

- (void)respring:(id)sender {
	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/shuffle.dylib"]) {
        [HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=Tweaks&path=Minimal"]];
    } else {
        [HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=Minimal"]];   
    }	
}


@end
