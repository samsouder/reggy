/* ReggyController */

#import <Cocoa/Cocoa.h>
#import <OgreKit/OgreKit.h>

@interface ReggyController : NSObject
{
	IBOutlet NSWindow * mainWindow;
	IBOutlet NSPanel * matchInfoPanel;
    IBOutlet NSButton * matchAllButton;
	IBOutlet NSButton * matchCaseButton;
	IBOutlet NSButton * matchMultiLineButton;
    IBOutlet NSTextView * regexPatternField;
    IBOutlet NSTextField * statusText;
    IBOutlet NSTextView * testingStringField;
	IBOutlet NSTextView * matchInfoText;
	
	BOOL matchAll;
	BOOL matchCase;
	BOOL matchMultiLine;
	BOOL colorGroups;
	BOOL hideErrorImage;
}

- (BOOL) matchAll;
- (void) setMatchAll:(BOOL)yesOrNo;

- (BOOL) matchCase;
- (void) setMatchCase:(BOOL)yesOrNo;

- (BOOL) matchMultiLine;
- (void) setMatchMultiLine:(BOOL)yesOrNo;

- (BOOL) colorGroups;
- (void) setColorGroups:(BOOL)yesOrNo;

- (BOOL) hideErrorImage;
- (void) setHideErrorImage:(BOOL)yesOrNo;

- (NSString *) regularExpression;
- (void) setRegularExpression:(NSString *)newString;

- (NSString *) testString;
- (void) setTestString:(NSString *)newString;

- (IBAction) openMatchInfoPanel:(id)sender;
- (IBAction) clearMatchInfoText:(id)sender;
- (IBAction) openPreferencesWindow:(id)sender;
- (IBAction) match:(id)sender;

- (int) syntaxForPreference:(NSString *)preference;
@end
