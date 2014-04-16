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
    
    self.imageView2.layer.cornerRadius = self.imageView2.frame.size.height / 2;
    self.imageView2.clipsToBounds = YES;
    
    self.imageView.clipsToBounds = YES;
}

- (IBAction)openPhotoView:(id)sender
{
    // Set up photo view
    CAPSPhotoView *photoView = [[CAPSPhotoView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)
                                                          dateTitle:@"Date: 03/12/2014"
                                                              title:@"Title"
                                                           subtitle:@"Subtitle"];
    
    // Open/Fade in photo view from original image
    [photoView fadeInPhotoViewFromImageView:self.imageView];
}

- (IBAction)openPhotoView2:(id)sender
{
    // Set up photo view
    CAPSPhotoView *photoView = [[CAPSPhotoView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)
                                                          dateTitle:@"Date: 03/12/2014"
                                                              title:@"Title"
                                                           subtitle:@"Subtitle"];
    
    // Open/Fade in photo view from original image
    [photoView fadeInPhotoViewFromImageView:self.imageView2];
}

- (IBAction)openPhotoView3:(id)sender
{
    // Set up photo view
    CAPSPhotoView *photoView = [[CAPSPhotoView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)
                                                          dateTitle:@"Date: 03/12/2014"
                                                              title:@"Title"
                                                           subtitle:@"Subtitle"];
    
    // Open/Fade in photo view from original image
    [photoView fadeInPhotoViewFromImageView:self.imageView3];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
