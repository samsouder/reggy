//
//  ReggyController_Toolbar.m
//  Reggy
//
//  Created by Samuel Souder on 9/1/07.
//

#import "ReggyController.h"

static NSString * ReggyToolbarIdentifier				= @"Reggy Toolbar Identifier";
static NSString * RunExpressionToolbarItemIdentifier	= @"Run Expression Item Identifier";
static NSString * AddExpressionToolbarItemIdentifier	= @"Add Expression Item Identifier";
static NSString * RemoveExpressionToolbarItemIdentifier	= @"Remove Expression Item Identifier";
static NSString * ExportExpressionToolbarItemIdentifier	= @"Export Expression Item Identifier";
static NSString * ExpressionInfoToolbarItemIdentifier	= @"Expression Information Item Identifier";

@implementation ReggyController(Toolbar)

- (void)setupToolbarForWindow:(NSWindow *)theWindow
{
	NSToolbar *toolbar = [[[NSToolbar alloc] initWithIdentifier: ReggyToolbarIdentifier] autorelease];
    
	[toolbar setVisible:YES];
	[toolbar setAllowsUserCustomization:YES];
	[toolbar setShowsBaselineSeparator:YES];
	[toolbar setAutosavesConfiguration: YES];
	[toolbar setDisplayMode: NSToolbarDisplayModeIconAndLabel];
	
	[toolbar setDelegate: self];
	
    [theWindow setToolbar:toolbar];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar
{
	return [NSArray arrayWithObjects: RunExpressionToolbarItemIdentifier, NSToolbarSpaceItemIdentifier, AddExpressionToolbarItemIdentifier, RemoveExpressionToolbarItemIdentifier, ExportExpressionToolbarItemIdentifier, NSToolbarFlexibleSpaceItemIdentifier, ExpressionInfoToolbarItemIdentifier, nil];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar
{
	return [NSArray arrayWithObjects: RunExpressionToolbarItemIdentifier, NSToolbarSpaceItemIdentifier, AddExpressionToolbarItemIdentifier, RemoveExpressionToolbarItemIdentifier, ExportExpressionToolbarItemIdentifier, NSToolbarFlexibleSpaceItemIdentifier, ExpressionInfoToolbarItemIdentifier, NSToolbarFlexibleSpaceItemIdentifier, NSToolbarSpaceItemIdentifier, NSToolbarSeparatorItemIdentifier, NSToolbarCustomizeToolbarItemIdentifier, NSToolbarShowFontsItemIdentifier, NSToolbarShowColorsItemIdentifier, NSToolbarPrintItemIdentifier, nil];
}

- (BOOL)validateToolbarItem:(NSToolbarItem *)toolbarItem
{
	// Do custom validation on the [toolbarItem identifier] here
    return YES;
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)willBeInserted
{
	NSToolbarItem *toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier: itemIdentifier] autorelease];
	
    if ( [itemIdentifier isEqual:RunExpressionToolbarItemIdentifier] )
	{
		[toolbarItem setLabel:@"Run"];
		[toolbarItem setPaletteLabel:@"Run"];
		[toolbarItem setToolTip:@"Run Regular Expression"];
		[toolbarItem setImage:[NSImage imageNamed:@"Play"]];
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(match:)];
	}
	else if ( [itemIdentifier isEqual:AddExpressionToolbarItemIdentifier] )
	{
		[toolbarItem setLabel:@"Add"];
		[toolbarItem setPaletteLabel:@"Add"];
		[toolbarItem setToolTip:@"Add Regular Expression"];
		[toolbarItem setImage:[NSImage imageNamed: @"Add"]];
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(windowDidResize:)];
	}
	else if ( [itemIdentifier isEqual:RemoveExpressionToolbarItemIdentifier] )
	{
		[toolbarItem setLabel:@"Remove"];
		[toolbarItem setPaletteLabel:@"Remove"];
		[toolbarItem setToolTip:@"Remove Regular Expression"];
		[toolbarItem setImage:[NSImage imageNamed: @"Remove"]];
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(windowDidResize:)];
	}
	else if ( [itemIdentifier isEqual:ExportExpressionToolbarItemIdentifier] )
	{
		[toolbarItem setLabel:@"Export"];
		[toolbarItem setPaletteLabel:@"Export"];
		[toolbarItem setToolTip:@"Export Regular Expression"];
		[toolbarItem setImage:[NSImage imageNamed: @"LinkBack"]];
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(windowDidResize:)];
	}
	else if ( [itemIdentifier isEqual:ExpressionInfoToolbarItemIdentifier] )
	{
		[toolbarItem setLabel:@"Show Info"];
		[toolbarItem setPaletteLabel:@"Show Info"];
		[toolbarItem setToolTip:@"Show Regular Expression Match Information"];
		[toolbarItem setImage:[NSImage imageNamed: @"Get Info"]];
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(openMatchInfoPanel:)];
	}
	else
	{
		toolbarItem = nil;
	}
	
	return toolbarItem;
}

@end
