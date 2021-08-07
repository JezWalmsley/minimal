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

    if(![self minimalIconView]) {
        self.minimalIconView = [UIImageView new];
        [[self minimalIconView] setImage:[[self icons] objectAtIndex:0]];
        [[self minimalIconView] setContentMode:UIViewContentModeScaleAspectFit];
        [[self minimalIconView] setClipsToBounds:YES];
        
        // Constaints
        // https://gist.github.com/Luki120/ee994ddca38ab693944eee9a503bb475

        self.minimalIconView = [[UIImageView alloc] init];
        self.minimalIconView = [self addSubview:self.minimalIconView];
        self.minimalIconView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.minimalIconView.topAnchor constraintEqualToAnchor: [self topAnchor]].active = YES;
    }

}

%end

