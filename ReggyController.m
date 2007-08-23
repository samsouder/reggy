#import "ReggyController.h"
#import "ReggyPrefsWindowController.h"

@implementation ReggyController

#pragma mark -
#pragma mark Initialization
+ (void) initialize
{
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
		@"Ruby", @"default_syntax",
		@"YES", @"match_all",
		@"NO", @"match_case",
		@"YES", @"multiline",
		[NSArchiver archivedDataWithRootObject:[NSColor colorWithCalibratedHue:0.6 saturation:1.0 brightness:1.0 alpha:1.0]], @"match_color", nil];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self setMatchAll:[[NSUserDefaults standardUserDefaults] boolForKey:@"match_all"]];
		[self setMatchCase:[[NSUserDefaults standardUserDefaults] boolForKey:@"match_case"]];
		[self setMatchMultiLine:[[NSUserDefaults standardUserDefaults] boolForKey:@"multiline"]];
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
	[mainWindow setBackgroundColor:[NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
	
	// Add a toolbar
	NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"styled_toolbar"];
	[toolbar setDelegate:self];
	[toolbar setVisible:YES];
	[toolbar setAllowsUserCustomization:YES];
	[mainWindow setToolbar:toolbar];
	[toolbar release];
	
	[regexPatternField setToolTip:@"Regular Expression"];
	[testingStringField setToolTip:@"Testing String"];
	
	// Call the match: action for the first time
	[self performSelector:@selector(match:)];
	
	// Select all the text in the regexPattern NSTextView so it's easy to just start typing
	[regexPatternField selectAll:self];
}

#pragma mark -
#pragma mark Toolbar
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
	return [NSArray arrayWithObjects:@"Tool", @"Button", @"Item", nil];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
	return [NSArray arrayWithObjects:@"TestItem", @"TestItem2", @"TestItem3", nil];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
	NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:@"ToolbarItem"];
	[item setLabel:@"Toolbar Item"];
	[item setImage:[NSImage imageNamed:@"NSApplicationIcon"]];
	[item setTarget:mainWindow];
	[item setAction:@selector(windowDidResize:)];
	
    return [item autorelease];
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
	[[NSUserDefaults standardUserDefaults] setBool:yesOrNo forKey:@"match_all"];
	[self performSelector:@selector(match:)];
}

- (BOOL) matchCase
{
	return matchCase;
}
- (void) setMatchCase:(BOOL)yesOrNo
{
	matchCase = yesOrNo;
	[[NSUserDefaults standardUserDefaults] setBool:yesOrNo forKey:@"match_case"];
	[self performSelector:@selector(match:)];
}

- (BOOL) matchMultiLine
{
	return matchMultiLine;
}

- (void) setMatchMultiLine:(BOOL)yesOrNo
{
	matchMultiLine = yesOrNo;
	[[NSUserDefaults standardUserDefaults] setBool:yesOrNo forKey:@"multiline"];
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

- (void) changeColor: (id)sender
{
	[self performSelector:@selector(match:)];
}

#pragma mark -
#pragma mark Actions
- (IBAction) openPreferencesWindow:(id)sender
{
	[[ReggyPrefsWindowController sharedPrefsWindowController] showWindow:nil];
}

- (IBAction) match:(id)sender
{
	// NSColor * lightBlueColor = [NSColor colorWithCalibratedRed:0.5 green:.5 blue:1.0 alpha:1.0];
	// NSColor * lightBlueColor = [NSColor colorWithCalibratedHue:0.6 saturation:1.0 brightness:1.0 alpha:1.0];
	
	NSRange totalRange;
	unsigned int totalLength = [[testingStringField textStorage] length];
	totalRange.location = 0;
	totalRange.length = totalLength;
	
	// Remove all old colors
	[[testingStringField textStorage] removeAttribute:NSForegroundColorAttributeName range:totalRange];
	
	OGRegularExpression * regEx;
	[OGRegularExpression setDefaultEscapeCharacter:@"\\"];
	[OGRegularExpression setDefaultSyntax:[self syntaxForPreference:[[NSUserDefaults standardUserDefaults] stringForKey:@"default_syntax"]]];
	
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
			
			// Add new color to matched range
			//[[testingStringField textStorage] addAttribute:NSForegroundColorAttributeName value:lightBlueColor range:matchRange];
			[[testingStringField textStorage] addAttribute:NSForegroundColorAttributeName
												value:[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"match_color"]]
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

#pragma mark -
#pragma mark Utilities
- (int) syntaxForPreference:(NSString *)preference
{
	/*
	 if(syntax == OgreSimpleMatchingSyntax)	return &OgrePrivateRubySyntax;
	 if(syntax == OgrePOSIXBasicSyntax)		return &OgrePrivatePOSIXBasicSyntax;
	 if(syntax == OgrePOSIXExtendedSyntax)	return &OgrePrivatePOSIXExtendedSyntax;
	 if(syntax == OgreEmacsSyntax)			return &OgrePrivateEmacsSyntax;
	 if(syntax == OgreGrepSyntax)			return &OgrePrivateGrepSyntax;
	 if(syntax == OgreGNURegexSyntax)		return &OgrePrivateGNURegexSyntax;
	 if(syntax == OgreJavaSyntax)			return &OgrePrivateJavaSyntax;
	 if(syntax == OgrePerlSyntax)			return &OgrePrivatePerlSyntax;
	 if(syntax == OgreRubySyntax)			return &OgrePrivateRubySyntax;
	 */
	// DEBUG
	// NSLog(@"OgreSimpleMatchingSyntax = %d\nOgrePOSIXBasicSyntax = %d\nOgrePOSIXExtendedSyntax = %d\nOgreEmacsSyntax = %d\nOgreGrepSyntax = %d\nOgreGNURegexSyntax = %d\nOgreJavaSyntax = %d\nOgrePerlSyntax = %d\nOgreRubySyntax = %d", OgreSimpleMatchingSyntax, OgrePOSIXBasicSyntax, OgrePOSIXExtendedSyntax, OgreEmacsSyntax, OgreGrepSyntax, OgreGNURegexSyntax, OgreJavaSyntax, OgrePerlSyntax, OgreRubySyntax);
	
	int ogrekit_syntax = OgreSimpleMatchingSyntax;
	
	if ( [preference isEqualToString:@"POSIX Basic"] )
	{
		ogrekit_syntax = OgrePOSIXBasicSyntax;
	}
	else if ( [preference isEqualToString:@"POSIX Extended"] )
	{
		ogrekit_syntax = OgrePOSIXExtendedSyntax;
	}
	else if ( [preference isEqualToString:@"Ruby"] )
	{
		ogrekit_syntax = OgreRubySyntax;
	}
	else if ( [preference isEqualToString:@"Perl"] )
	{
		ogrekit_syntax = OgrePerlSyntax;
	}
	else if ( [preference isEqualToString:@"Java"] )
	{
		ogrekit_syntax = OgreJavaSyntax;
	}
	else if ( [preference isEqualToString:@"GNU"] )
	{
		ogrekit_syntax = OgreGNURegexSyntax;
	}
	else if ( [preference isEqualToString:@"Grep"] )
	{
		ogrekit_syntax = OgreGrepSyntax;
	}
	else if ( [preference isEqualToString:@"Emacs"] )
	{
		ogrekit_syntax = OgreEmacsSyntax;
	}
	else
	{
		ogrekit_syntax = OgreRubySyntax;
	}
	
	// DEBUG
	// NSLog(@"Getting syntax for preference: %@", preference);
	// NSLog(@"Outcome: %d", ogrekit_syntax);
	
	return ogrekit_syntax;
}

@end
