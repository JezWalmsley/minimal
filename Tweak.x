#import "Tweak.h"

%hook NCNotificationShortLookView 

%property(nonatomic, retain)UIView* minimalView;
// %property(nonatomic, retain)UIBlurEffect* minimalBlur;
// %property(nonatomic, retain)UIVisualEffectView* minimalBlurView;
%property(nonatomic, strong)UIImageView* minimalIconView;
// %property(nonatomic, retain)UILabel* minimalTitleLabel;

-(void)didMoveToWindow {

    %orig;

    if (![[[self _viewControllerForAncestor] delegate] isKindOfClass:%c(SBNotificationBannerDestination)]) return; // check if the notification is a banner

    // Remove the banner
    // https://github.com/schneelittchen/Liddell/blob/main/Tweak/Liddell.x
    for (UIView* subview in [self subviews]) {
        if (subview == [self minimalView]) continue;
        [subview setHidden:YES];
    }
    // Set view ontop of area 

    if (![self minimalView]) {
        self.minimalView = [UIView new];
        [[self minimalView] setClipsToBounds:YES];
        self.minimalView.backgroundColor = [UIColor clearColor]; // Poopy dot syntax
    
        [self addSubview:[self minimalView]];

        [[self minimalView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [self.minimalView.topAnchor constraintEqualToAnchor:self.topAnchor constant:-30], // y  axis
            [self.minimalView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:30], // x axis
            [self.minimalView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor], 
            [self.minimalView.heightAnchor constraintEqualToConstant:30],
        ]];
    }
    
    // Icon View
    if(![self minimalIconView]) {
        self.minimalIconView = [UIImageView new];
        [[self minimalIconView] setImage:[[self icons] objectAtIndex:0]];
        [[self minimalIconView] setContentMode:UIViewContentModeScaleAspectFit];
        [[self minimalIconView] setClipsToBounds:YES];
        [[self minimalView] addSubview:[self minimalIconView]]; 
        
        // Constaints
        // https://gist.github.com/Luki120/ee994ddca38ab693944eee9a503bb475

        [[self minimalIconView] setTranslatesAutoresizingMaskIntoConstraints:NO];

         [NSLayoutConstraint activateConstraints:@[
            [self.minimalIconView.leadingAnchor constraintEqualToAnchor:self.minimalIconView.leadingAnchor constant:8],
            [self.minimalIconView.centerYAnchor constraintEqualToAnchor:self.minimalIconView.centerYAnchor],
            [self.minimalIconView.heightAnchor constraintEqualToConstant:30],
            [self.minimalIconView.widthAnchor constraintEqualToConstant:30],
        ]];
        
        if([self minimalIconView]) {
            [_UIStatusBarStringView setText:@""];
        }

    }

}

%end

