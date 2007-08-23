#import "ReggyPrefsWindowController.h"

@implementation ReggyPrefsWindowController

- (void) setupToolbar
{
	[self addView:generalPrefsView label:@"General"];
	[self addView:advancedPrefsView label:@"Advanced"];
}

- (IBAction)openRegularExpressionHelpInBrowser:(id)sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://en.wikipedia.org/wiki/Regex#Syntax"]];
}

@end
