#import <UIKit/UIKit.h>
#import "PXRColorWheel.h"
#import "PXRColorPickerDecorator.h"

@class PXRColorPicker;
/**
 Delegate for a PXRColorPicker.
 */
@protocol PXRColorPickerDelegate <NSObject>
/**
 Called when the user is done picking a color.
 @param colorPicker The PXRColorPicker that changed the color.
 @param color The color selected in the PXRColorPicker.
 */
- (void)colorPicker:(PXRColorPicker*)colorPicker pickedColor:(UIColor*)color;
/**
 Called whenever the user has updated the color via a swatch, slider or the color wheel
 @param colorPicker The PXRColorPicker that cancelled.
 */
- (void)colorPickerCancelled:(PXRColorPicker*)colorPicker;
@optional
/**
 Called when the user has cancelled picking a color.
 @param colorPicker The PXRColorPicker that picked the color.
 @param color The color selected in the PXRColorPicker.
 */
- (void)colorPicker:(PXRColorPicker *)colorPicker changedColor:(UIColor *)color;
@end

/**
 A view controller for picking colors in an ios application.
 <p>
 <strong>Example Usage:</strong><br/>
 <code>
 <pre>
 - (IBAction)openColorPicker:(UIButton*)sender{
	PXRColorPicker *colorPicker = [[PXRColorPicker alloc] init];
	colorPicker.delegate = self;
	[self presentViewController:colorPicker animated:YES completion:^{}];
 }
 
 - (void)colorPicker:(PXRColorPicker *)colorPicker pickedColor:(UIColor *)color{
	NSLog(@"picked color %@", color);
	[self dismissViewControllerAnimated:YES completion:^{}];
 }
 
 - (void)colorPickerCancelled:(PXRColorPicker *)colorPicker{
	[self dismissViewControllerAnimated:YES completion:^{}];
 }
 </pre>
 </code>
 </p>
 */
@interface PXRColorPicker : UIViewController <PXRColorWheelDelegate>{
	float _h;
	float _s;
	float _b;
	float _a;
	BOOL _dragging;
}
/**
 The delegate for the color picker. See PXRColorPickerDelegate for more info.
 */
@property (weak) NSObject <PXRColorPickerDelegate> *delegate;
/**
 The current UIColor in the picker has selected.
 */
@property (strong, readonly) UIColor *currentColor;
/**
 A prefix to use for NSUserDefaults that will define what the naming convention of the saving of swatches and the main color.<br /> Setting this to a unique string per document can let the user have a picker with swatches and a main color that are unique to that document.
 */
@property (strong) NSString *defaultsPrefix;
/**
 The amount of steps the lighter and darker buttons will go by for setting brightness.  
 */
@property NSUInteger brightnessIncrement;
/**
 An array of UIButtons to use as swatches. For use in a custom nib.
 */
@property (strong) IBOutletCollection(UIButton) NSArray *swatches;
/**
 A UISlider to be used to set the opacity of the color. For use in a custom nib.
 */
@property (weak) IBOutlet UISlider *alphaSlider;
/**
 A UISlider to be used to set the hue of the color. For use in a custom nib.
 */
@property (weak) IBOutlet UISlider *tintSlider;
/**
 A PXRColorWheel that will update the color when the user moves a finger over it. For use in a custom nib.
 */
@property (weak) IBOutlet PXRColorWheel *colorWheel;
/**
 A UIImageView the LED that appears over the tintSlider that will show the user where they have selected. For use in a custom nib.
 */
@property (weak) IBOutlet UIImageView *wheelLed;
/**
 A UIView that shows the main color. For use in a custom nib.
 */
@property (weak) IBOutlet UIView *colorLed;
/**
 A UIView that shows when the user has tapped on the main LED. Dragging over a swatch will let the user set that swatch. For use in a custom nib.
 */
@property (strong) IBOutlet UIView *dragLed;
/**
 A UIButton that a user can tap to make the color darker. For use in a custom nib.
 */
@property (weak) IBOutlet UIButton *darkerButton;
/**
 A UIButton that a user can tap to make the color lighter. For use in a custom nib.
 */
@property (weak) IBOutlet UIButton *lighterButton;



/**
 Changes the hue of the main color.  Can be hooked up to the tintSlider UIControlEventValueChanged event.
 @param sender The UISlider sending the update.
 */
- (IBAction)changeHue:(UISlider*)sender;
/**
 Changes the opacity of the main color.  Can be hooked up to the alphaSlider UIControlEventValueChanged event.
 @param sender The UISlider sending the update.
 */
- (IBAction)changeAlpha:(UISlider*)sender;
/**
 Changes the color to the background color of a swatch.  Can be hooked up to each of the UIControlEventTouchUpInside events in for swatches.
 @param sender The UIButton sending the update.
 */
- (IBAction)changeColorFromSwatch:(UIButton*)sender;
/**
 Notifies the delegate that the picker has picked a color. By default hooked up to a "done" button.  
 @param sender The UIButton sending the update.
 */
- (IBAction)onOk:(UIButton*)sender;
/**
 Notifies the delegate that the picker has cancelled picking. By default hooked up to a "cancel" button.
 @param sender The UIButton sending the update.
 */
- (IBAction)onCancel:(UIButton*)sender;
/**
 Darkens the color by the amount of steps set in brightnessIncrement. Can be hooked up to the darkerButton UIControlEventTouchUpInside event.
 @param sender The UIButton sending the update.
 */
- (IBAction)darker:(UIButton*)sender;
/**
 Lightens the color by the amount of steps set in brightnessIncrement. Can be hooked up to the lighterButton UIControlEventTouchUpInside event.
 @param sender The UIButton sending the update.
 */
- (IBAction)lighter:(UIButton*)sender;
/**
 Saves the colors and swatches to NSUserDefaults using defaultsPrefix.
 */
- (void)saveColors;

@end
