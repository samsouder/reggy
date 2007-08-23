//
//  SSToolbarResizeView.m
//
//  Created by Samuel Souder on 8/23/07.
//

#import "SSToolbarResizeView.h"

@implementation SSToolbarResizeView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
	[self drawResizeLinesWithColor:[NSColor colorWithCalibratedRed:0.25 green:0.25 blue:0.25 alpha:1.0]
							 count:3
							 width:1
						   spacing:1
					   rightMargin:5
						 topMargin:5
					  bottomMargin:5];
}

- (void)drawResizeLinesWithColor:(NSColor *)color count:(int)lineCount width:(int)lineWidth spacing:(int)lineSpacing rightMargin:(int)rightMargin topMargin:(int)topMargin bottomMargin:(int)bottomMargin
{
	int count = lineCount;
	while ( count > 0 ) {
		int x, y, width, height;
		
		x = [self bounds].size.width - rightMargin - lineWidth;
		if ( count != lineCount ) x -= ((lineSpacing * 2) * count);
		y = bottomMargin;
		width = lineWidth;
		height = [self bounds].size.height - (topMargin * 2);
		
		NSRect lineRect = NSMakeRect(x, y, width, height);
		NSBezierPath * vertLine = [NSBezierPath bezierPathWithRect:lineRect];
		[color set];
		[vertLine fill];
		
		count--;
	}
}

@end
