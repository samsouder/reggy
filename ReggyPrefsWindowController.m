#import "ReggyPrefsWindowController.h"


@implementation ReggyPrefsWindowController

- (void) setupToolbar
{
	[self addView:generalPrefsView label:@"General"];
	[self addView:advancedPrefsView label:@"Advanced"];
}

@end
