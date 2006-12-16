#import "ReggyController.h"

@implementation ReggyController

#pragma mark -
#pragma mark init & awakeFromNib
- (id) init
{
	self = [super init];
	if (self != nil) {
		[self set_matchAll:YES];
		[self set_matchCase:NO];
		[self set_matchMultiLine:NO];
		[self set_hideErrorImage:YES];
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
	// Also Note: _match* are bound to NSButtons in IB
	
	[mainWindow setBackgroundColor:[NSColor colorWithCalibratedWhite:0.8 alpha:1.0]];
	
	[regexPattern setToolTip:@"Regular Expression"];
	[testingString setToolTip:@"Testing String"];
	
	// Call the match: action for the first time
	[self performSelector:@selector(match:)];
	
	// Select all the text in the regexPattern NSTextView so it's easy to just start typing
	[regexPattern selectAll:self];
}

#pragma mark -
#pragma mark Accessors
- (BOOL) _matchAll
{
	return _matchAll;
}
- (void) set_matchAll:(BOOL)yesOrNo
{
	_matchAll = yesOrNo;
	[self performSelector:@selector(match:)];
}

- (BOOL) _matchCase
{
	return _matchCase;
}
- (void) set_matchCase:(BOOL)yesOrNo
{
	_matchCase = yesOrNo;
	[self performSelector:@selector(match:)];
}

- (BOOL) _matchMultiLine
{
	return _matchMultiLine;
}

- (void) set_matchMultiLine:(BOOL)yesOrNo
{
	_matchMultiLine = yesOrNo;
	[self performSelector:@selector(match:)];
}

- (BOOL) _hideErrorImage
{
	return _hideErrorImage;
}
- (void) set_hideErrorImage:(BOOL)yesOrNo
{
	_hideErrorImage = yesOrNo;
}


#pragma mark -
#pragma mark Delegate Methods
- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
	return YES;
}

- (void) textDidChange:(NSNotification *)aNotification
{
	[self performSelector:@selector(match:)];
}

#pragma mark -
#pragma mark Actions
- (IBAction) match:(id)sender
{
	//NSColor * lightBlueColor = [NSColor colorWithCalibratedRed:0.5 green:.5 blue:1.0 alpha:1.0];
	NSColor * lightBlueColor = [NSColor colorWithCalibratedHue:0.6 saturation:1.0 brightness:1.0 alpha:1.0];
	NSRange totalRange;
	unsigned int totalLength = [[testingString textStorage] length];
	totalRange.location = 0;
	totalRange.length = totalLength;
	
	// Remove all old colors
	[[testingString textStorage] removeAttribute:NSForegroundColorAttributeName	range:totalRange];
	
	OGRegularExpression * regEx;
	[OGRegularExpression setDefaultEscapeCharacter:@"\\"];
	[OGRegularExpression setDefaultSyntax:OgreRubySyntax];
	
	NS_DURING
		// options: OgreFindNotEmptyOption | OgreCaptureGroupOption | OgreIgnoreCaseOption | OgreMultilineOption?
		unsigned int options;
		options = OgreFindNotEmptyOption;
		if ( ![self _matchCase] )
			options |= OgreIgnoreCaseOption;
		if ( [self _matchMultiLine] )
			options |= OgreMultilineOption;
		regEx = [OGRegularExpression regularExpressionWithString:[regexPattern string] options:options];
	NS_HANDLER
		[self set_hideErrorImage:NO];
		[statusText setStringValue:[NSString stringWithFormat:@"RegEx Error: %@", [localException reason]]];
		return;
	NS_ENDHANDLER
	
	[self set_hideErrorImage:YES];
	
	OGRegularExpressionMatch * match;
	match = [regEx matchInString:[testingString string]];
	if ( match == nil )
	{
		[statusText setStringValue:@"No Matches Found"];
		return;
	}
	
	NSEnumerator * enumerator = [regEx matchEnumeratorInString:[testingString string]];
	
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
			//[[testingString textStorage] addAttribute:NSForegroundColorAttributeName value:lightBlueColor range:matchRange];
			[[testingString textStorage] addAttribute:NSForegroundColorAttributeName
												value:lightBlueColor
												range:matchRange];
		}
		
		// If we don't want to show all matches, just exit here.
		if ( ![self _matchAll] ) break;
		
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
