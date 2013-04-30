#import "PXRColorPickerDecorator.h"
#import "PXRColorPicker.h"

#define kCheckerSize 12.0f
#define D_2_R (3.141592653589/180.0)

void DrawCheckeredPattern (void *info, CGContextRef context){
	CGFloat scale = [[UIScreen mainScreen] scale];
    UIColor *bgColor = [UIColor colorWithRed:0.205f green:0.205f blue:0.205f alpha:1.000f];
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
	float checkHalf = scale * (kCheckerSize/2);
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, checkHalf, checkHalf));
	CGContextFillRect(context, CGRectMake(checkHalf, checkHalf, checkHalf, checkHalf));
}

@interface PXRColorPickerDecorator(hidden)
- (void)stylizeColorItem:(UIView*)item;
- (void)stylizeNavButton:(UIButton*)button;
- (void)addShineToView:(UIView*)view;
- (UIView*)checkerBoardBackgroundForView:(UIView*)view;
- (UIImage*)imageForBackground;
@end

@implementation PXRColorPickerDecorator

- (void)decorate:(PXRColorPicker*)colorPicker{
	UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 460.0f)];
	//mainView.backgroundColor = [UIColor colorWithRed:0.225f green:0.225f blue:0.225f alpha:1.000f];
	mainView.backgroundColor = [[UIColor alloc] initWithPatternImage:[self imageForBackground]];
	colorPicker.view = mainView;
	
	// create a nav container
	UIView *navContainer = [self createNavContainer];
	[mainView addSubview:navContainer];
	
	// create the color wheel
	PXRColorWheel *cw = [self createColorWheel];
	colorPicker.colorWheel = cw;
	[mainView addSubview:cw];
	
	// create the swatches
	NSArray *swatches = [self createSwatches];
	colorPicker.swatches = swatches;
	UIView *swatchBG;
	for(UIButton *swatch in swatches){
		[mainView addSubview:swatch];
		[swatch addTarget:colorPicker action:@selector(changeColorFromSwatch:) forControlEvents:UIControlEventTouchUpInside];
		swatchBG = [self checkerBoardBackgroundForView:swatch];
		[mainView addSubview:swatchBG];
		[mainView insertSubview:swatchBG belowSubview:swatch];
	}
	
	// create the main led
	UIView *colorLed = [self createColorLED];
	colorPicker.colorLed = colorLed;
	[mainView addSubview:colorLed];
	// craete a background image for it
	UIView *ledBG = [self checkerBoardBackgroundForView:colorLed];
	[mainView addSubview:ledBG];
	[mainView insertSubview:ledBG belowSubview:colorLed];
	
	// create the drag drop LED
	UIView *dragLED = [self createColorLED];
	colorPicker.dragLed = dragLED;
	
	// create the hue slider
	UISlider *hueSlider = [self createHueSlider];
	[mainView addSubview:hueSlider];
	colorPicker.tintSlider = hueSlider;
	[hueSlider addTarget:colorPicker action:@selector(changeHue:) forControlEvents:UIControlEventValueChanged];
	
	// create the alpha slider
	UISlider *alphaSlider = [self createAlphaSlider];
	[mainView addSubview:alphaSlider];
	colorPicker.alphaSlider = alphaSlider;
	[alphaSlider addTarget:colorPicker action:@selector(changeAlpha:) forControlEvents:UIControlEventValueChanged];
	
	// create darker and lighter
	UIButton *darkerButton = [self createDarkerButton];
	[mainView addSubview:darkerButton];
	colorPicker.darkerButton = darkerButton;
	[darkerButton addTarget:colorPicker action:@selector(darker:) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *lighterButton = [self createLighterButton];
	[mainView addSubview:lighterButton];
	colorPicker.lighterButton = lighterButton;
	[lighterButton addTarget:colorPicker action:@selector(lighter:) forControlEvents:UIControlEventTouchUpInside];
	
	// create the color wheel LED
	UIImageView *cwLED = [self createColorWheelLED];
	[mainView addSubview:cwLED];
	colorPicker.wheelLed = cwLED;
	
	// done and cancel buttons
	UIButton *doneButton = [self createDoneButton];
	[navContainer addSubview:doneButton];
	[doneButton addTarget:colorPicker action:@selector(onOk:) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *cancelButton = [self createCancelButton];
	[navContainer addSubview:cancelButton];
	[cancelButton addTarget:colorPicker action:@selector(onCancel:) forControlEvents:UIControlEventTouchUpInside];
}

- (PXRColorWheel*)createColorWheel{
	PXRColorWheel *colorWheel = [[PXRColorWheel alloc] initWithFrame:CGRectMake(50.0f, 129.0f, 213.0f, 143.0f)];
	colorWheel.layer.borderWidth = 1.0f;
	colorWheel.layer.borderColor = [UIColor blackColor].CGColor;
	return colorWheel;
}

- (NSArray*)createSwatches{
	int rows = 4;
	int cols = 5;
	int y, x;
	float xPos = 51.0f;
	float yPos = 280.0f;
	float width = 35.0f;
	float height = 35.0f;
	float padding = 9.0f;
	NSMutableArray *swatches = [[NSMutableArray alloc] init];
	
	for(y=0; y<rows; y++){
		for(x=0; x<cols; x++){
			UIButton *swatch = [[UIButton alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
			[self addShineToView:swatch];
			[self stylizeColorItem:swatch];
			xPos += width + padding;
			[swatches addObject:swatch];
		}
		xPos = 51.0f;
		yPos += height + padding;
	}
	return swatches;
}

- (UIView*)createColorLED{
	UIView *colorLED = [[UIView alloc] initWithFrame:CGRectMake(125.0f, 50.0f, 70.0f, 70.0f)];
	[self stylizeColorItem:colorLED];
	return colorLED;
}

- (UISlider*)createHueSlider{
	UISlider *hueSlider = [[UISlider alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 23.0f)];
	hueSlider.center = CGPointMake(292.0f, 288.0f);

	UIGraphicsBeginImageContext(CGSizeMake(hueSlider.frame.size.width, hueSlider.frame.size.height));
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
	
	int hueCount = 9;
	float hueInc = 1.0f/8;
	float h = 0.0f;
	// create a gradient with all the hues we need
	CGFloat locations[9];
	CGFloat colors[9 * 4];
	float r, g, b, a;
	int pos = 0;

	for(int i=0; i<8; i++){
		pos = i * 4;
		UIColor *color = [UIColor colorWithHue:h saturation:1.0f brightness:1.0f alpha:1.0f];
		[color getRed:&r green:&g blue:&b alpha:&a];
		colors[pos] = r;
		colors[pos + 1] = g;
		colors[pos + 2] = b;
		colors[pos + 3] = a;
		locations[i] = h;
		h += hueInc;
	}
	
	// now add in the first color again
	UIColor *color = [UIColor colorWithHue:1.0f saturation:1.0f brightness:1.0f alpha:1.0f];
	[color getRed:&r green:&g blue:&b alpha:&a];
	pos = 8 * 4;
	colors[pos] = r;
	colors[pos + 1] = g;
	colors[pos + 2] = b;
	colors[pos + 3] = a;
	locations[8] = 1.0f;
	
	for(int i=0; i<9; i++){
		pos = i *4;
		NSLog(@"location: %f color: %.2f %.2f %.2f", locations[i], colors[pos], colors[pos+1], colors[pos + 2]);
	}
	
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, colors, locations, hueCount);
	
    CGPoint startPoint = CGPointMake(0.0f, 0.0f);
    CGPoint endPoint = CGPointMake(hueSlider.frame.size.width, 0.0f);
	
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
	gradient = NULL;
	
	UIGraphicsPopContext();
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	UIImage *sliderBarImage1 = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
	UIImage *sliderBarImage2 = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
	
	[hueSlider setMaximumTrackImage:sliderBarImage1 forState:UIControlStateNormal];
	[hueSlider setMinimumTrackImage:sliderBarImage2 forState:UIControlStateNormal];
	[hueSlider setThumbImage:[self imageForSlider] forState:UIControlStateNormal];
	
	[self stylizeSlider:hueSlider];
	
	return hueSlider;
}

- (UISlider*)createAlphaSlider{
	UISlider *alphaSlider = [[UISlider alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 23.0f)];
	alphaSlider.center = CGPointMake(22.0f, 288.0f);
	
	CGFloat scale = [[UIScreen mainScreen] scale];
	CGRect rect = CGRectMake(0, 0, alphaSlider.frame.size.width * scale, alphaSlider.frame.size.height * scale);
	
	UIGraphicsBeginImageContext(CGSizeMake(alphaSlider.frame.size.width * scale, alphaSlider.frame.size.height * scale));
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
	
	// add bg color
	UIColor *bgColor = [UIColor colorWithRed:0.692f green:0.692f blue:0.692f alpha:1.000f];
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextFillRect(context, rect);
	
	// add checkerboard pattern
	CGPatternCallbacks callbacks = {0, &DrawCheckeredPattern, NULL};
	CGContextSaveGState(context);
    CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace(context, patternSpace);
    CGColorSpaceRelease(patternSpace);
    CGPatternRef pattern = CGPatternCreate(NULL, CGRectMake(0, 0, kCheckerSize * scale, kCheckerSize * scale), CGAffineTransformIdentity, kCheckerSize * scale, kCheckerSize * scale, kCGPatternTilingNoDistortion, true, &callbacks);
    CGFloat alpha = 1.0;
    CGContextSetFillPattern(context, pattern, &alpha);
    CGPatternRelease(pattern);
	CGContextFillRect(context, CGRectMake(0, 0, alphaSlider.frame.size.width * scale, alphaSlider.frame.size.height * scale));
	CGContextRestoreGState(context);
	
	// add a gradient over it
	CGFloat locations[2] = {0.0f, 0.9f};
	CGFloat colors[8] = {
		1.0f, 1.0f, 1.0f, 0.0f,
		1.0f, 1.0f, 1.0f, 1.0f,
	};
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, colors, locations, 2);
    CGPoint startPoint = CGPointMake(0.0f, 0.0f);
    CGPoint endPoint = CGPointMake(alphaSlider.frame.size.width * scale, 0.0f);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
	gradient = NULL;
	
	UIGraphicsPopContext();
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	img = [UIImage imageWithCGImage:img.CGImage scale:scale orientation:UIImageOrientationUp];
	
	UIImage *sliderBarImage1 = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
	UIImage *sliderBarImage2 = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
	
	[alphaSlider setMaximumTrackImage:sliderBarImage1 forState:UIControlStateNormal];
	[alphaSlider setMinimumTrackImage:sliderBarImage2 forState:UIControlStateNormal];
	[alphaSlider setThumbImage:[self imageForSlider] forState:UIControlStateNormal];
	
	[self stylizeSlider:alphaSlider];
	
	return alphaSlider;
}

- (UIButton*)createDarkerButton{
	UIButton *darkerButton = [[UIButton alloc] initWithFrame:CGRectMake(9.0f, 62.0f, 72.0f, 44.0f)];
	[self stylizeColorItem:darkerButton];
	return darkerButton;
}

- (UIButton*)createLighterButton{
	UIButton *lighterButton = [[UIButton alloc] initWithFrame:CGRectMake(240.0f, 62.0f, 72.0f, 44.0f)];
	[self stylizeColorItem:lighterButton];
	return lighterButton;
}

- (UIImageView*)createColorWheelLED{
	CGFloat scale = [[UIScreen mainScreen] scale];
	
	UIGraphicsBeginImageContext(CGSizeMake(12.0f * scale, 12.0f * scale));
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
	
	CGContextSetLineWidth(context, 1.0f * scale);
	
	// draw the shadow
	CGRect shadowFrame = CGRectMake(3.0f * scale, 3.0f * scale, 8.0f * scale, 8.0f * scale);
	CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
	CGContextStrokeEllipseInRect(context, shadowFrame);
	
	CGRect highlightFrame = CGRectMake(2.0f * scale, 2.0f * scale, 8.0f * scale, 8.0f * scale);
	CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
	CGContextStrokeEllipseInRect(context, highlightFrame);
	
	UIGraphicsPopContext();
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
	imgView.contentMode = UIViewContentModeScaleToFill;
	imgView.frame = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
	return imgView;
}

- (UIView*)createNavContainer{
	UIView *navContainer = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)];
	navContainer.backgroundColor = [UIColor blackColor];
	
	CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = navContainer.layer.bounds;
    shineLayer.colors = @[(id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                          (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                          (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                          (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                          (id)[UIColor colorWithWhite:0.0f alpha:0.4f].CGColor];
	
    shineLayer.locations = @[[NSNumber numberWithFloat:0.0f],
                             [NSNumber numberWithFloat:0.5f],
                             [NSNumber numberWithFloat:0.5f],
                             [NSNumber numberWithFloat:0.8f],
                             [NSNumber numberWithFloat:1.0f]];
	
    [navContainer.layer addSublayer:shineLayer];
	return navContainer;
}

- (UIButton*)createDoneButton{
	UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(255.0f, 5.0f, 60.0f, 30.0f)];
	[doneButton setTitle:@"Done" forState:UIControlStateNormal];
	[self stylizeNavButton:doneButton];
	return doneButton;
}

- (UIButton*)createCancelButton{
	UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 60.0f, 30.0f)];
	[cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
	[self stylizeNavButton:cancelButton];
	return cancelButton;
}

- (void)stylizeNavButton:(UIButton*)button{
	button.layer.cornerRadius = 5.0f;
	button.layer.masksToBounds = YES;
	button.layer.borderWidth = 1.0f;
	button.layer.borderColor = [UIColor blackColor].CGColor;
	button.backgroundColor = [UIColor blackColor];
	button.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
	
	// add a shine
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = button.layer.bounds;
    shineLayer.colors = @[(id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
						  (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
						  (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
						  (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
						  (id)[UIColor colorWithWhite:0.8f alpha:0.4f].CGColor];
    shineLayer.locations = @[[NSNumber numberWithFloat:0.0f],
                             [NSNumber numberWithFloat:0.5f],
                             [NSNumber numberWithFloat:0.5f],
                             [NSNumber numberWithFloat:0.9f],
                             [NSNumber numberWithFloat:1.0f]];
    [button.layer addSublayer:shineLayer];
}

- (void)addShineToView:(UIView*)view{
	CAGradientLayer *shineLayer = [CAGradientLayer layer];
	
	float padding = 2.0f;
	CGRect shineFrame = view.layer.bounds;
	shineFrame.origin.x = view.layer.bounds.origin.x + padding;
	shineFrame.origin.y = view.layer.bounds.origin.y + padding;
	shineFrame.size.width = view.layer.bounds.size.width - (padding * 2);
	shineFrame.size.height = view.layer.bounds.size.height - (padding * 2);
	
	shineLayer.frame = shineFrame;
	
    shineLayer.colors = @[(id)[UIColor colorWithWhite:1.0f alpha:0.0f].CGColor,
                          (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                          (id)[UIColor colorWithWhite:0.1f alpha:0.05f].CGColor,
                          (id)[UIColor colorWithWhite:0.8f alpha:0.1f].CGColor,
                          (id)[UIColor colorWithWhite:0.2f alpha:0.0f].CGColor];
	
    shineLayer.locations = @[[NSNumber numberWithFloat:0.0f],
                             [NSNumber numberWithFloat:0.5f],
                             [NSNumber numberWithFloat:0.5f],
                             [NSNumber numberWithFloat:0.9f],
                             [NSNumber numberWithFloat:1.0f]];
	
    [view.layer addSublayer:shineLayer];
}

- (void)stylizeColorItem:(UIView*)item{
	item.layer.cornerRadius = 5.0f;
	item.layer.masksToBounds = YES;
	item.layer.borderWidth = 1.0f;
	item.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)stylizeSlider:(UISlider*)slider{
	slider.layer.cornerRadius = 0.0f;
	slider.layer.masksToBounds = YES;
	slider.backgroundColor = [UIColor clearColor];
	
	CGAffineTransform transform = CGAffineTransformMakeRotation(-90 * D_2_R);
	slider.transform = transform;
}

- (UIView*)checkerBoardBackgroundForView:(UIView*)view{
	CGFloat scale = [[UIScreen mainScreen] scale];
	
	UIGraphicsBeginImageContext(CGSizeMake(kCheckerSize * scale, kCheckerSize * scale));
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
	
	// add bg color
	UIColor *bgColor = [UIColor colorWithRed:0.692f green:0.692f blue:0.692f alpha:1.000f];
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, kCheckerSize * scale, kCheckerSize * scale));
	
	// add checkerboard pattern
	CGPatternCallbacks callbacks = {0, &DrawCheckeredPattern, NULL};
	CGContextSaveGState(context);
    CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace(context, patternSpace);
    CGColorSpaceRelease(patternSpace);
    CGPatternRef pattern = CGPatternCreate(NULL, CGRectMake(0, 0, kCheckerSize * scale, kCheckerSize * scale), CGAffineTransformIdentity, kCheckerSize * scale, kCheckerSize * scale, kCGPatternTilingNoDistortion, true, &callbacks);
    CGFloat alpha = 1.0;
    CGContextSetFillPattern(context, pattern, &alpha);
    CGPatternRelease(pattern);
	CGContextFillRect(context, CGRectMake(0, 0, kCheckerSize * scale, kCheckerSize * scale));
	CGContextRestoreGState(context);
	
	UIGraphicsPopContext();
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	img = [UIImage imageWithCGImage:img.CGImage scale:scale orientation:UIImageOrientationUp];
	
	UIView *bgView = [[UIView alloc] initWithFrame:view.frame];
	bgView.backgroundColor = [[UIColor alloc] initWithPatternImage:img];
	
	bgView.layer.cornerRadius = view.layer.cornerRadius;
	
	return bgView;
}

- (UIImage*)imageForBackground{
	CGFloat scale = [[UIScreen mainScreen] scale];
	float lineHeight = 4.0f;
	
	UIGraphicsBeginImageContext(CGSizeMake(1.0f * scale, lineHeight * scale));
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);

	// draw the shadow
	CGRect fillFrame = CGRectMake(0.0f * scale, 0.0f * scale, 1.0f * scale, lineHeight * scale);
	CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0.15f alpha:1.0f].CGColor);
	CGContextFillRect(context, fillFrame);
	
	CGRect lineFrame = CGRectMake(0.0f * scale, 0.0f * scale, 1.0f * scale, 1.0f * scale);
	CGContextSetFillColorWithColor(context,  [UIColor colorWithWhite:0.1f alpha:1.0f].CGColor);
	CGContextSetLineWidth(context, 1.0f * scale);
	CGContextFillRect(context, lineFrame);
	
	UIGraphicsPopContext();
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return [UIImage imageWithCGImage:img.CGImage scale:scale orientation:UIImageOrientationUp];
}


- (UIImage*)imageForSlider{
	CGFloat scale = [[UIScreen mainScreen] scale];
	
	float w = 23.0f;
	float h = 23.0f;
	
	UIGraphicsBeginImageContext(CGSizeMake(w * scale, h * scale));
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
	
	
	// add a gradient over it
	CGFloat locations[4] = {0.0f, 0.5f, 0.5f, 1.0f};
	CGFloat colors[16] = {
		1.0f, 1.0f, 1.0f, 0.3f,
		1.0f, 1.0f, 1.0f, 0.5f,
		1.0f, 1.0f, 1.0f, 0.8f,
		1.0f, 1.0f, 1.0f, 0.1f
	};
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, colors, locations, 4);
    CGPoint startPoint = CGPointMake(0.0f, 0.0f);
    CGPoint endPoint = CGPointMake(w * scale, 0.0f);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
	gradient = NULL;
	
	// stroke the edges
	CGRect strokeFrame = CGRectMake(1.0f * scale, 1.0f * scale, (w-2) * scale, (w-2) * scale);
	CGContextSetStrokeColorWithColor(context,  [UIColor blackColor].CGColor);
	CGContextStrokeRect(context, strokeFrame);
	
	UIGraphicsPopContext();
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return [UIImage imageWithCGImage:img.CGImage scale:scale orientation:UIImageOrientationUp];
}


@end
