#import "PXRColorPicker.h"

#define DARK_LIGHT_INCREMENT 0.2f

@implementation PXRColorPicker


- (id)init{
	self = [super init];
	self.brightnessIncrement = 5;
	
	PXRColorPickerDecorator *decorator = [[PXRColorPickerDecorator alloc] init];
	[decorator decorate:self];
	
	_h = 1.0f;
	_s = 1.0f;
	_b = 1.0f;
	_a = 1.0f;
	self.defaultsPrefix = @"_pxrcolorpicker";
	
	self.colorWheel.delegate = self;
	self.wheelLed.userInteractionEnabled = NO;
	self.dragLed.userInteractionEnabled = NO;
	self.colorLed.userInteractionEnabled = NO;
	[self setupSwatches];
	[self updateColorWheel];
	[self updateControlsFromColor];
	[self updateColor];
	[self loadColors];
	
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	self.brightnessIncrement = 5;
	
	_h = 1.0f;
	_s = 1.0f;
	_b = 1.0f;
	_a = 1.0f;
	self.defaultsPrefix = @"_pxrcolorpicker";
	[self updateColor];
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	self.colorWheel.delegate = self;
	self.wheelLed.userInteractionEnabled = NO;
	self.dragLed.userInteractionEnabled = NO;
	self.colorLed.userInteractionEnabled = NO;
	[self setupSwatches];
	[self updateColorWheel];
	[self updateControlsFromColor];
	[self updateColor];
	[self loadColors];
}

- (void)colorWheelChangedValue:(PXRColorWheel *)cw{
	_h = cw.hue;
	_s = cw.saturation;
	_b = cw.brightness;
	[self updateColorWheel];
	[self updateControlsFromColor];
	[self updateColor];
}

- (IBAction)changeHue:(UISlider*)sender{
	_h = sender.value;
	[self updateColorWheel];
	[self updateColor];
}

- (IBAction)changeAlpha:(UISlider*)sender{
	_a = sender.value;
	[self updateColor];
}

- (void)setupSwatches{
	// set some default values if needed
	UIButton *sw;
	float defH = 0;
	float defS = 1;
	float defB = 1;
	float inc = 1.0f/(float)self.swatches.count;
	int ind = 0;
	int i;
	if(self.swatches.count > 0){
		sw = [self.swatches objectAtIndex:0];
		sw.backgroundColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:1.0 alpha:1.0];
		ind++;
	}
	i=0;
	for(UIButton *sw in self.swatches){
		sw.backgroundColor = [UIColor colorWithHue:defH saturation:defS brightness:defB alpha:1.0];
		defH += inc;
		i++;
	}
}

- (IBAction)changeColorFromSwatch:(UIButton*)sender{
	float h, s, b, a;
	[sender.backgroundColor getHue:&h saturation:&s brightness:&b alpha:&a];
	_h = h;
	_s = s;
	_b = b;
	_a = a;
	[self updateColorWheel];
	[self updateControlsFromColor];
	[self updateColor];
}

- (void)updateControlsFromColor{
	self.alphaSlider.value = _a;
	self.tintSlider.value = _h;
}

- (void)updateColorWheel{
	self.colorWheel.hue = _h;
	float posX = (_s * _colorWheel.frame.size.width) - (self.wheelLed.frame.size.width/2);
	float posY = ((1.0f - _b) * _colorWheel.frame.size.height) - (self.wheelLed.frame.size.height/2);
	CGRect ledFrame = self.wheelLed.frame;
	ledFrame.origin.x = posX + _colorWheel.frame.origin.x;
	ledFrame.origin.y = posY + _colorWheel.frame.origin.y;
	self.wheelLed.frame = ledFrame;
}

- (void)updateColor{
	_currentColor = [UIColor colorWithHue:_h saturation:_s brightness:_b alpha:_a];
	self.colorLed.backgroundColor = self.currentColor;
	
	// set the color of the dark and light buttons
	float darker = _b - (1.0f/self.brightnessIncrement);
	if(darker < 0.0f){
		darker = 0.0f;
	}
	self.darkerButton.backgroundColor = [UIColor colorWithHue:_h saturation:_s brightness:darker alpha:1.0f];
	
	float lighter = _b + (1.0f/self.brightnessIncrement);
	if(lighter > 1.0f){
		lighter = 1.0f;
	}
	self.lighterButton.backgroundColor = [UIColor colorWithHue:_h saturation:_s brightness:lighter alpha:1.0f];
	
	if(self.delegate){
		if([self.delegate respondsToSelector:@selector(colorPicker:changedColor:)]){
			[self.delegate colorPicker:self changedColor:[UIColor colorWithHue:_h saturation:_s brightness:_b alpha:_a]];
		}
	}
}

- (void)startDrag{
	[self.view addSubview:self.dragLed];
	self.dragLed.backgroundColor = [UIColor colorWithHue:_h saturation:_s brightness:_b alpha:_a];
	_dragging = YES;
}

- (void)stopDrag{
	// hit test the frame against all the swatches
	CGPoint hitPoint = self.dragLed.center;
	for(UIButton *swatch in self.swatches){
		if(CGRectContainsPoint(swatch.frame, hitPoint)){
			swatch.backgroundColor = [UIColor colorWithHue:_h saturation:_s brightness:_b alpha:_a];
			break;
		}
	}
	[self.dragLed removeFromSuperview];
	[self saveColors];
	_dragging = NO;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
	NSSet *viewTouches = [event allTouches];
	UITouch *touch1 = [[viewTouches allObjects] objectAtIndex:0];
	CGPoint location = [touch1 locationInView:self.view];
	BOOL needsToStartDrag = CGRectContainsPoint(self.colorLed.frame, location);
	if(needsToStartDrag){
		[self startDrag];
		[self updateDragFrameWith:touches andEvent:event];
	}
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event{
	if(_dragging){
		[self updateDragFrameWith:touches andEvent:event];
	}
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event{
	if(_dragging){
		[self stopDrag];
	}
}

- (void)updateDragFrameWith:(NSSet*)touches andEvent:(UIEvent*)event{
	NSSet *viewTouches = [event allTouches];
	UITouch *touch1 = [[viewTouches allObjects] objectAtIndex:0];
	CGPoint location = [touch1 locationInView:self.view];
	CGRect dragFrame = self.dragLed.frame;
	dragFrame.origin.x = location.x - (dragFrame.size.width/2);
	dragFrame.origin.y = location.y - (dragFrame.size.height/2);
	self.dragLed.frame = dragFrame;
}

- (IBAction)onOk:(UIButton*)sender{
	[self saveColors];
	UIColor *final = [UIColor colorWithHue:_h saturation:_s brightness:_b alpha:_a];
	if(self.delegate){
		[self.delegate colorPicker:self pickedColor:final];
	}
}

- (IBAction)onCancel:(UIButton*)sender{
	[self saveColors];
	if(self.delegate){
		[self.delegate colorPickerCancelled:self];
	}
}

- (IBAction)darker:(UIButton*)sender{
	_b = _b - (1.0f/self.brightnessIncrement);
	if(_b < 0.0f) _b = 0.0f;
	[self updateColorWheel];
	[self updateControlsFromColor];
	[self updateColor];
}

- (IBAction)lighter:(UIButton*)sender{
	_b = _b + (1.0f/self.brightnessIncrement);
	if(_b > 1.0f) _b = 1.0f;
	[self updateColorWheel];
	[self updateControlsFromColor];
	[self updateColor];
}

- (void)loadColors{
	// load swatches
	NSArray *currentSwatch;
	UIColor *swatchColor;
	int i=0;
	for(UIButton *sw in self.swatches){
		NSString *swatchKey = [self.defaultsPrefix stringByAppendingFormat:@"_swatches_%d", i];
		currentSwatch = [[NSUserDefaults standardUserDefaults] objectForKey:swatchKey];
		if(currentSwatch){
			swatchColor = [self hsbToColor:currentSwatch];
			if(swatchColor){
				sw.backgroundColor = swatchColor;
			}
		}
		i++;
	}
	// load colors
	NSString *colorKey = [self.defaultsPrefix stringByAppendingString:@"_currentColor"];
	NSArray *currentColor = [[NSUserDefaults standardUserDefaults] objectForKey:colorKey];
	if(currentColor){
		_h = [[currentColor objectAtIndex:0] floatValue];
		_s = [[currentColor objectAtIndex:1] floatValue];
		_b = [[currentColor objectAtIndex:2] floatValue];
		_a = [[currentColor objectAtIndex:3] floatValue];
		[self updateColorWheel];
		[self updateControlsFromColor];
		[self updateColor];
	}
}

- (void)saveColors{
	// save swatches
	int i=0;
	for(UIButton *sw in self.swatches){
		NSArray *vals = [self colorToHSB:sw.backgroundColor];
		NSString *swatchKey = [self.defaultsPrefix stringByAppendingFormat:@"_swatches_%d", i];
		[[NSUserDefaults standardUserDefaults] setObject:vals forKey:swatchKey];
		i++;
	}
	
	// save color
	NSString *colorKey = [self.defaultsPrefix stringByAppendingString:@"_currentColor"];
	[[NSUserDefaults standardUserDefaults] setObject:[self colorToHSB:self.currentColor] forKey:colorKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray*)colorToHSB:(UIColor*)color{
	float h, s, b, a;
	[color getHue:&h saturation:&s brightness:&b alpha:&a];
	return @[[NSNumber numberWithFloat:h], [NSNumber numberWithFloat:s], [NSNumber numberWithFloat:b], [NSNumber numberWithFloat:a]];
}

- (UIColor*)hsbToColor:(NSArray*)hsb{
	return [UIColor colorWithHue:[[hsb objectAtIndex:0] floatValue] saturation:[[hsb objectAtIndex:1] floatValue] brightness:[[hsb objectAtIndex:2] floatValue] alpha:[[hsb objectAtIndex:3] floatValue]];
}


@end
