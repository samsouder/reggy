/* ReggyController */

#import <Cocoa/Cocoa.h>
#import <OgreKit/OgreKit.h>

@interface ReggyController : NSObject
{
	IBOutlet NSWindow * mainWindow;
    IBOutlet NSButton * matchAll;
	IBOutlet NSButton * matchCase;
	IBOutlet NSButton * matchMultiLine;
    IBOutlet NSTextView * regexPattern;
    IBOutlet NSTextField * statusText;
    IBOutlet NSTextView * testingString;
	
	BOOL _matchAll;
	BOOL _matchCase;
	BOOL _matchMultiLine;
	BOOL _hideErrorImage;
}

- (BOOL) _matchAll;
- (void) set_matchAll:(BOOL)yesOrNo;

- (BOOL) _matchCase;
- (void) set_matchCase:(BOOL)yesOrNo;

- (BOOL) _matchMultiLine;
- (void) set_matchMultiLine:(BOOL)yesOrNo;

- (BOOL) _hideErrorImage;
- (void) set_hideErrorImage:(BOOL)yesOrNo;

- (IBAction) match:(id)sender;
@end
