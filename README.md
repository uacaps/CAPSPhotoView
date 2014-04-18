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
* <code>CAPSPhotoView.xib</code>

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
// Open CAPSPhotoView as modal
[photoView openPhotoViewAsModalWithImageView:imageView];
```

## Future Work

The following feature will be added in the future:

* Swipe through an array of images
* Support for collection views
* Performance enhancements
* Removing need for xib file
