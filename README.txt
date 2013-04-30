------------------------------------------------------------------------------
        __                __                      __         __               
.-----.|__|.--.--..-----.|  |.----..-----..--.--.|__|.-----.|__|.-----..-----.
|  _  ||  ||_   _||  -__||  ||   _||  -__||  |  ||  ||__ --||  ||  _  ||     |
|   __||__||__.__||_____||__||__|  |_____| \___/ |__||_____||__||_____||__|__|
|__|                                                                          
------------------------------------------------------------------------------


******************************************************************************
IOS Color Picker
******************************************************************************

What is it?
A color picker for IOS to model the hue slider as seen in photoshop.

Setup:
1. Drag the contents of the "source" folder into your project and check "copy items into destination group's folder".
2. Import "PXRColorPicker.h"

Usage:
The delegate callbacks are:
- (void)colorPicker:(PXRColorPicker*)colorPicker pickedColor:(UIColor*)color;
- (void)colorPickerCancelled:(PXRColorPicker*)colorPicker;
- (void)colorPicker:(PXRColorPicker *)colorPicker changedColor:(UIColor *)color;

An example project is located in the example folder.  There is documentation in the docs folder.

******************************************************************************
License - MIT
******************************************************************************

Copyright (c) 2013 pixelrvision

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.