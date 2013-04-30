#import "PXRViewController.h"

@implementation PXRViewController


- (IBAction)openColorPicker:(UIButton*)sender{
	PXRColorPicker *colorPicker = [[PXRColorPicker alloc] init];
	colorPicker.delegate = self;
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
		_popover = [[UIPopoverController alloc] initWithContentViewController:colorPicker];
		_popover.popoverContentSize = CGSizeMake(320.0f, 480.0f);
		[_popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:TRUE];
	}else{
		[self presentViewController:colorPicker animated:YES completion:^{}];
	}
}

- (void)colorPicker:(PXRColorPicker *)colorPicker pickedColor:(UIColor *)color{
	self.view.backgroundColor = color;
	if(_popover){
		[_popover dismissPopoverAnimated:YES];
		_popover = nil;
	}else{
		[self dismissViewControllerAnimated:YES completion:^{}];
	}
}

- (void)colorPickerCancelled:(PXRColorPicker *)colorPicker{
	if(_popover){
		[_popover dismissPopoverAnimated:YES];
		_popover = nil;
	}else{
		[self dismissViewControllerAnimated:YES completion:^{}];
	}
}

@end
