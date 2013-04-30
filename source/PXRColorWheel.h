#import <UIKit/UIKit.h>

@class PXRColorWheel;

/**
 <p>
 Delegate responsible for passing updates.
 </p>
 */
@protocol PXRColorWheelDelegate
/**
 <p>
 Called as the user touches the color wheel to change the saturation and brightness.
 @param cw The PXRColorWheel that changed value.
 </p>
 */
- (void)colorWheelChangedValue:(PXRColorWheel*)cw;
@end

/**
 <p>
 A view for rendering a gradient of color at a hue and sending updates to a delegate as the user touches it.
 </p>
 */
@interface PXRColorWheel : UIView

/**
 <p>
 The delegate for a color wheel. See PXRColorWheelDelegate for more info.
 </p>
 */
@property (weak) NSObject <PXRColorWheelDelegate> *delegate;
/**
 <p>
 Sets the selected hue
 </p>
 */
@property (nonatomic) float hue;
@property (nonatomic) float saturation;
@property (nonatomic) float brightness;

- (void)updateColorAtLocation:(CGPoint)location;

@end
