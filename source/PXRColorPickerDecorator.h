#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@class PXRColorPicker;
@class PXRColorWheel;

/**
 Class responsible for setting up default views in PXRColorPicker
 */
@interface PXRColorPickerDecorator : NSObject

/**
 Decorates the color picker with all of its views.
 @param colorPicker The PXRColorPicker to decorate.
 */
- (void)decorate:(PXRColorPicker*)colorPicker;
/**
 Creates a stylized color wheel for use in PXRColorPicker.
 */
- (PXRColorWheel*)createColorWheel;
/**
 Creates an array of stylized swatches for use in PXRColorPicker.
 */
- (NSArray*)createSwatches;
/**
 Creates a stylized main color led for use in PXRColorPicker.
 */
- (UIView*)createColorLED;
/**
 Creates a stylized hue slider for use in PXRColorPicker.
 */
- (UISlider*)createHueSlider;
/**
 Creates a stylized alpha slider for use in PXRColorPicker.
 */
- (UISlider*)createAlphaSlider;
/**
 Creates a stylized darker button for use in PXRColorPicker.
 */
- (UIButton*)createDarkerButton;
/**
 Creates a stylized lighter button for use in PXRColorPicker.
 */
- (UIButton*)createLighterButton;
/**
 Creates a stylized color wheel led for use in PXRColorPicker.
 */
- (UIImageView*)createColorWheelLED;
/**
 Creates a stylized view to show as a container for the done and cancel buttons for use in PXRColorPicker.
 */
- (UIView*)createNavContainer;
/**
 Creates a stylized done button for use in PXRColorPicker.
 */
- (UIButton*)createDoneButton;
/**
 Creates a stylized cancel button for use in PXRColorPicker.
 */
- (UIButton*)createCancelButton;

@end
