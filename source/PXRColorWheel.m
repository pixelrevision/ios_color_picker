#import "PXRColorWheel.h"
@interface PXRColorWheel (hidden)
- (void)updateColorAtLocation:(CGPoint)location;
@end

@implementation PXRColorWheel

- (id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	return self;
}

- (void)setHue:(float)h{
	_hue = h;
	[self setNeedsDisplay];
}

- (void)setSaturation:(float)saturation{
	_saturation = saturation;
	[self setNeedsDisplay];
}

- (void)setBrightness:(float)brightness{
	_brightness = brightness;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef colorspace;
	colorspace = CGColorSpaceCreateDeviceRGB();
	
	// create the base
	UIColor *base = [UIColor colorWithHue:self.hue saturation:1.0 brightness:1.0 alpha:1.0];
	const CGFloat *col = CGColorGetComponents(base.CGColor);
	CGContextSetRGBFillColor(context, col[0], col[1], col[2], col[3]);
	CGContextFillRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
	
	// create the white gradient
	CGGradientRef whiteGradient;
	size_t white_num_locations = 2;
	CGFloat whiteLocations[2] = {0.0, 1.0};
	CGFloat whiteComponents[8] = {1.0, 1.0, 1.0, 1.0,
		1.0, 1.0, 1.0, 0.0};
	whiteGradient = CGGradientCreateWithColorComponents(colorspace, whiteComponents, whiteLocations, white_num_locations);
	CGContextDrawLinearGradient(context, whiteGradient, CGPointMake(0, 0), CGPointMake(self.frame.size.width, 0), kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(whiteGradient);
	
	// draw black gradient
	size_t black_num_locations = 2;
	CGFloat blackLocations[2] = {0.0, 1.0};
	CGFloat blackComponents[8] = {0.0, 0.0, 0.0, 1.0,
								  0.0, 0.0, 0.0, 0.0};
	CGGradientRef blackGradient = CGGradientCreateWithColorComponents(colorspace, blackComponents, blackLocations, black_num_locations);
	CGContextDrawLinearGradient(context, blackGradient, CGPointMake(0, self.frame.size.height), CGPointMake(0, 0), kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(blackGradient);
	CGColorSpaceRelease(colorspace);
	[super drawRect:rect];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesBegan:touches withEvent:event];
	NSSet *viewTouches = [event allTouches];
	UITouch *touch1 = [[viewTouches allObjects] objectAtIndex:0];
	CGPoint location = [touch1 locationInView:self];
	[self updateColorAtLocation:location];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesMoved:touches withEvent:event];
	NSSet *viewTouches = [event allTouches];
	UITouch *touch1 = [[viewTouches allObjects] objectAtIndex:0];
	CGPoint location = [touch1 locationInView:self];
	[self updateColorAtLocation:location];
}

- (void)updateColorAtLocation:(CGPoint)location{
	float b = location.y/self.frame.size.height;
	b = 1-b;
	if(b > 1) b = 1;
	if(b < 0) b = 0;
	
	float s = location.x/self.frame.size.width;
	if(s > 1) s = 1;
	if(s < 0) s = 0;
	
	self.brightness = b;
	self.saturation = s;
	if(self.delegate){
		[self.delegate colorWheelChangedValue:self];
	}
}

@end
