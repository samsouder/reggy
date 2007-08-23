//
//  NSBezierPath_SSAdditions.m
//
//  Created by Samuel Souder on 8/22/07.
//  Based on code found at: http://www.cocoadev.com/index.pl?GradientFill
//

#import "NSBezierPath_SSAdditions.h"

@implementation NSBezierPath (SSAdditions)

- (void)fillGradientFrom:(NSColor*)inStartColor to:(NSColor*)inEndColor
{
	CIImage * coreimage;
	
	inStartColor = [inStartColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	inEndColor = [inEndColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	
	CIColor * startColor = [CIColor colorWithRed:[inStartColor redComponent] green:[inStartColor greenComponent] blue:[inStartColor blueComponent] alpha:[inStartColor alphaComponent]];
	CIColor * endColor = [CIColor colorWithRed:[inEndColor redComponent] green:[inEndColor greenComponent] blue:[inEndColor blueComponent] alpha:[inEndColor alphaComponent]];
	
	CIFilter * filter;
	filter = [CIFilter filterWithName:@"CILinearGradient"];
	[filter setValue:startColor forKey:@"inputColor0"];
	[filter setValue:endColor forKey:@"inputColor1"];
	
	CIVector * startVector;
	CIVector * endVector;
	startVector = [CIVector vectorWithX:0.0 Y:0.0];
	endVector = [CIVector vectorWithX:0.0 Y:[self bounds].size.height];
	
	[filter setValue:startVector forKey:@"inputPoint0"];
	[filter setValue:endVector forKey:@"inputPoint1"];
	
	coreimage = [filter valueForKey:@"outputImage"];
	
	[[NSGraphicsContext currentContext] saveGraphicsState];
	
	CIContext * context;
	
	context = [[NSGraphicsContext currentContext] CIContext];
	
	[self setClip];
	
	[context drawImage:coreimage atPoint:CGPointZero fromRect:CGRectMake( 0.0, 0.0, [self bounds].size.width + 100.0, [self bounds].size.height + 100.0 )];
	
	[[NSGraphicsContext currentContext] restoreGraphicsState];
}

@end