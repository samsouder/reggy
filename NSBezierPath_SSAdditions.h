//
//  NSBezierPath_SSAdditions.h
//
//  Created by Samuel Souder on 8/22/07.
//  Based on code found at: http://www.cocoadev.com/index.pl?GradientFill
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface NSBezierPath (SSAdditions)

- (void)fillGradientFrom:(NSColor*)inStartColor to:(NSColor*)inEndColor;

@end
