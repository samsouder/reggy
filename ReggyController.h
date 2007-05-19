/* ReggyController */

#import <Cocoa/Cocoa.h>
#import <OgreKit/OgreKit.h>

@interface ReggyController : NSObject
{
	IBOutlet NSWindow * mainWindow;
    IBOutlet NSButton * matchAllButton;
	IBOutlet NSButton * matchCaseButton;
	IBOutlet NSButton * matchMultiLineButton;
    IBOutlet NSTextView * regexPatternField;
    IBOutlet NSTextField * statusText;
    IBOutlet NSTextView * testingStringField;
	
	BOOL matchAll;
	BOOL matchCase;
	BOOL matchMultiLine;
	BOOL hideErrorImage;
}

- (BOOL) matchAll;
- (void) setMatchAll:(BOOL)yesOrNo;

- (BOOL) matchCase;
- (void) setMatchCase:(BOOL)yesOrNo;

- (BOOL) matchMultiLine;
- (void) setMatchMultiLine:(BOOL)yesOrNo;

- (BOOL) hideErrorImage;
- (void) setHideErrorImage:(BOOL)yesOrNo;

- (NSString *) regularExpression;
- (void) setRegularExpression:(NSString *)newString;

- (NSString *) testString;
- (void) setTestString:(NSString *)newString;

- (IBAction) openPreferencesWindow:(id)sender;
- (IBAction) match:(id)sender;

- (int) syntaxForPreference:(NSString *)preference;
@end
