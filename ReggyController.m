#import "ReggyController.h"

@implementation ReggyController

#pragma mark -
#pragma mark init & awakeFromNib
- (id) init
{
	self = [super init];
	if (self != nil) {
		[self setMatchAll:YES];
		[self setMatchCase:NO];
		[self setMatchMultiLine:YES];
		[self setHideErrorImage:YES];
	}
	
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

- (void) awakeFromNib
{
	// Note: I set up the regexPattern & testingString delegates to this controller object in IB
	// Also Note: match* are bound to NSButtons in IB
	
	[mainWindow setBackgroundColor:[NSColor colorWithCalibratedWhite:0.8 alpha:1.0]];
	
	[regexPatternField setToolTip:@"Regular Expression"];
	[testingStringField setToolTip:@"Testing String"];
	
	// Call the match: action for the first time
	[self performSelector:@selector(match:)];
	
	// Select all the text in the regexPattern NSTextView so it's easy to just start typing
	[regexPatternField selectAll:self];
}

#pragma mark -
#pragma mark Accessors
- (BOOL) matchAll
{
	return matchAll;
}
- (void) setMatchAll:(BOOL)yesOrNo
{
	matchAll = yesOrNo;
	[self performSelector:@selector(match:)];
}

- (BOOL) matchCase
{
	return matchCase;
}
- (void) setMatchCase:(BOOL)yesOrNo
{
	matchCase = yesOrNo;
	[self performSelector:@selector(match:)];
}

- (BOOL) matchMultiLine
{
	return matchMultiLine;
}

- (void) setMatchMultiLine:(BOOL)yesOrNo
{
	matchMultiLine = yesOrNo;
	[self performSelector:@selector(match:)];
}

- (BOOL) hideErrorImage
{
	return hideErrorImage;
}
- (void) setHideErrorImage:(BOOL)yesOrNo
{
	hideErrorImage = yesOrNo;
}

- (NSString *) regularExpression
{
	return [regexPatternField string];
}
- (void) setRegularExpression:(NSString *)newString
{
	[regexPatternField setString:newString];
}

- (NSString *) testString
{
	return [testingStringField string];
}
- (void) setTestString:(NSString *)newString
{
	[testingStringField setString:newString];
}


#pragma mark -
#pragma mark Delegate Methods
- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
	return YES;
}

- (void) textDidChange:(NSNotification *)aNotification
{
	[self performSelector:@selector(match:)];
}

- (BOOL) application:(NSApplication *)sender delegateHandlesKey:(NSString *)key
{
	if ( [key isEqual:@"regularExpression"] || [key isEqual:@"testString"] || [key isEqual:@"matchAll"] || [key isEqual:@"matchCase"] || [key isEqual:@"matchMultiLine"] ) {
		return YES;
	} else {
		return NO;
	}
}

#pragma mark -
#pragma mark Actions
- (IBAction) match:(id)sender
{
	//NSColor * lightBlueColor = [NSColor colorWithCalibratedRed:0.5 green:.5 blue:1.0 alpha:1.0];
	NSColor * lightBlueColor = [NSColor colorWithCalibratedHue:0.6 saturation:1.0 brightness:1.0 alpha:1.0];
	NSRange totalRange;
	unsigned int totalLength = [[testingStringField textStorage] length];
	totalRange.location = 0;
	totalRange.length = totalLength;
	
	// Remove all old colors
	[[testingStringField textStorage] removeAttribute:NSForegroundColorAttributeName	range:totalRange];
	
	OGRegularExpression * regEx;
	[OGRegularExpression setDefaultEscapeCharacter:@"\\"];
	[OGRegularExpression setDefaultSyntax:OgreRubySyntax];
	
	NS_DURING
		// options: OgreFindNotEmptyOption | OgreCaptureGroupOption | OgreIgnoreCaseOption | OgreMultilineOption?
		unsigned int options;
		options = OgreFindNotEmptyOption;
		if ( ![self matchCase] )
			options |= OgreIgnoreCaseOption;
		if ( [self matchMultiLine] )
			options |= OgreMultilineOption;
		regEx = [OGRegularExpression regularExpressionWithString:[regexPatternField string] options:options];
	NS_HANDLER
		[self setHideErrorImage:NO];
		[statusText setStringValue:[NSString stringWithFormat:@"RegEx Error: %@", [localException reason]]];
		return;
	NS_ENDHANDLER
	
	[self setHideErrorImage:YES];
	
	OGRegularExpressionMatch * match;
	match = [regEx matchInString:[testingStringField string]];
	if ( match == nil )
	{
		[statusText setStringValue:@"No Matches Found"];
		return;
	}
	
	NSEnumerator * enumerator = [regEx matchEnumeratorInString:[testingStringField string]];
	
	OGRegularExpressionMatch * lastMatch = nil;
	unsigned int matchesRunThrough = 0;
	
	while ( (match = [enumerator nextObject]) != nil )
	{
		// Run through the matches to colorize
		for ( unsigned int i = 0; i < [match count]; i++ )
		{
			// Get matched range
			NSRange	matchRange = [match rangeOfSubstringAtIndex:i];
			
			// Add new color ro matched range
			//[[testingStringField textStorage] addAttribute:NSForegroundColorAttributeName value:lightBlueColor range:matchRange];
			[[testingStringField textStorage] addAttribute:NSForegroundColorAttributeName
												value:lightBlueColor
												range:matchRange];
		}
		
		// If we don't want to show all matches, just exit here.
		if ( ![self matchAll] ) break;
		
		matchesRunThrough++;
		lastMatch = match;
	}
	
	// Set the status text for how many matches we ran through
	if ( matchesRunThrough > 1 )
		[statusText setStringValue:[NSString stringWithFormat:@"%d Matches Found", matchesRunThrough]];
	else
		[statusText setStringValue:@"1 Match Found"];
}

@end
