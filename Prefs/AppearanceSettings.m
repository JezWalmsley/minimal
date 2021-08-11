#import "Headers/RootListController.h"

@implementation AppearanceSettings

-(UIColor *)tintColor {
    return [UIColor colorWithRed:0.64 green:0.67 blue:1.00 alpha:1.0];;
}

-(UIColor *)navigationBarTitleColor {
    return [UIColor blackColor];
}


-(UIColor *)tableViewCellSeparatorColor {
    return [UIColor colorWithWhite:0 alpha:0];
}


-(BOOL)translucentNavigationBar {
    return NO;
}

- (NSUInteger)largeTitleStyle {
    return 2;
}

@end