## CAPSPhotoView (PRE-RELEASE)

CAPSPhotoView is a pop-out, facebook-style photo viewer for showing an image. It can be opened with a fade-in animation as well as a modal animation. CAPSPhotoView can be triggered from anywhere, i.e. button, tap-gesture, etc.

The following features are included in CAPSPhotoView:

* Fade-in from UIImageView (supports UIImageViews with corner radius)
* Open CAPSPhotoView with modal animation
* Swipe up/down to close 
* Close button
* Close animation back to original UIImageView or off-screen for modal
* Tap to show/hide detail view
* Double-tap to zoom
* Pinch to zoom

## Installation

**Cocoa Pods**

Coming in the future.

**Manual Installation**

All the classes required for CAPSPhotoView are located in the CAPSPhotoView folder in the root of this repository. They are listed below:

* <code>CAPSPhotoView.h</code>
* <code>CAPSPhotoView.h</code>

## Preview

![PhotoViewPreview](https://raw.githubusercontent.com/uacaps/ResourceRepo/master/CAPSPhotoView/PhotoViewPreviewLoop.gif)

## How to use CAPSPhotoView

**Initialization**

To set up and initialize CAPSPhotoView simply use the code below replacing the parameters with your own values:

```objective-c
// Initialize CAPSPhotoView
CAPSPhotoView *photoView = [[CAPSPhotoView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)
                                                      dateTitle:@"Date: 03/12/2014"
                                                          title:@"Title"
                                                       subtitle:@"Subtitle"];
```

**Open CAPSPhotoView**

To open up CAPSPhotoView you have the choice of fading it in from an existing UIImageView or opening it as modal from an existing UIImageView using the code below:

```objective-c
// Fade in CAPSPhotoView
[photoView fadeInPhotoViewFromImageView:imageView];
```
```objective-c
// Create UIImage view
UIImageView *modalImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo.jpg"]];

// Open CAPSPhotoView as modal
[photoView openPhotoViewAsModalWithImageView:imageView];
```

**Storyboard**

In order for the status bar to show and hide properly you will need to add 'View controller-based status bar appearance' and set it to 'NO' in your plist.

**User Customization**

The distance that is needed swiping up/down in order for the photo view to close can be customized by setting 'bounce range. 

```objective-c
// Set bounce range
photoView.bounceRange = 100;
```

The minimum, maximum, and double tap zoom scales can be set by setting 'minZoomScale', 'maxZoomScale', and 'doubleTapZoomScale'.

```objective-c
// Set minimum zoom scale
photoView.minZoomScale = 1.0;

// Set maximum zoom scale
photoView.maxZoomScale = 4.0;

// Set double tap zoom scale
photoView.doubleTapZoomScale = 2.0;
```

## Future Work

The following feature will be added in the future:

* Swipe through an array of images
* Support for collection views
* Performance enhancements
* Support for rotation of device
* Loading images dynamically

## License ##

Copyright (c) 2014 The Board of Trustees of The University of Alabama
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
 3. Neither the name of the University nor the names of the contributors
    may be used to endorse or promote products derived from this software
    without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.
