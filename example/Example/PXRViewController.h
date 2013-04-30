#import <UIKit/UIKit.h>
#import "PXRColorPicker.h"

@interface PXRViewController : UIViewController <PXRColorPickerDelegate>{
	UIPopoverController *_popover;
}

- (IBAction)openColorPicker:(UIButton*)sender;

@end
