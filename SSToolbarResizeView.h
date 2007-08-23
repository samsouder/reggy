//
//  SSToolbarResizeView.h
//
//  Created by Samuel Souder on 8/23/07.
//

#import <Cocoa/Cocoa.h>

@interface SSToolbarResizeView : NSView {
}

- (void)drawResizeLinesWithColor:(NSColor *)color count:(int)lineCount width:(int)lineWidth spacing:(int)lineSpacing rightMargin:(int)rightMargin topMargin:(int)topMargin bottomMargin:(int)bottomMargin;

@end
