//
//  SSToolbarView.m
//
//  Created by Samuel Souder on 8/22/07.
//

#import "SSToolbarView.h"

@implementation SSToolbarView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
	NSColor * startColor = [NSColor colorWithCalibratedRed:0.773 green:0.773 blue:0.773 alpha:1.0];
	// NSColor * endColor = [NSColor colorWithCalibratedRed:0.588 green:0.588 blue:0.588 alpha:1.0];
	// NSColor * borderColor = [NSColor colorWithCalibratedRed:0.251 green:0.251 blue:0.251 alpha:1.0];
	
	NSBezierPath * path = [NSBezierPath bezierPathWithRect:rect];
	[startColor set];
	[path fill];
	// [path fillGradientFrom:startColor to:endColor];
	
	// [borderColor set];
	// [path stroke];
}

@end
