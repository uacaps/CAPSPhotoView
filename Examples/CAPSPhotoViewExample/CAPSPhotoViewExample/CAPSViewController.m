//
//  CAPSViewController.m
//  CAPSPhotoViewExample
//
//  Created by Niklas Fahl on 4/14/14.
//  Copyright (c) 2014 CAPS. All rights reserved.
//

#import "CAPSViewController.h"
#import "CAPSPhotoView.h"

@interface CAPSViewController ()

@end

@implementation CAPSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Set device height and width variables
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float deviceWidth = screenRect.size.width;
    float deviceHeight = screenRect.size.height;
    
    // Image view with corner radius
    self.imageView2.layer.cornerRadius = self.imageView2.frame.size.height / 2;
    self.imageView2.clipsToBounds = YES;
    
    // Set up photo view
    photoView = [[CAPSPhotoView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth, deviceHeight)
                                           dateTitle:@"Date: 03/12/2014"
                                               title:@"Title"
                                            subtitle:@"Subtitle"];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
//    photoView.transform = CGAffineTransformMakeRotation(M_PI/2);
}

- (IBAction)openPhotoView:(id)sender
{
    // Open/Fade in photo view from original image view
    [photoView fadeInPhotoViewFromImageView:self.imageView];
}

- (IBAction)openPhotoView2:(id)sender
{
    // Open/Fade in photo view from original image view
    [photoView fadeInPhotoViewFromImageView:self.imageView2];
}

- (IBAction)openPhotoView3:(id)sender
{
    // Open/Fade in photo view from original image view
    [photoView fadeInPhotoViewFromImageView:self.imageView3];
}

- (IBAction)openPhotoView4:(id)sender
{
    // Open/Fade in photo view from original image view
    [photoView fadeInPhotoViewFromImageView:self.imageView4];
}

- (IBAction)openPhotoViewAsModal:(id)sender
{
    // Create UIImage view
    UIImageView *modalImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sign.jpg"]];
    
    // Open photo view as modal with image view
    [photoView openPhotoViewAsModalWithImageView:modalImageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
