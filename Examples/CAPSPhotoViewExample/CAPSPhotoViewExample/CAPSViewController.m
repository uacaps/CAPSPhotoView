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
}

- (IBAction)openPhotoView:(id)sender
{
    CAPSPhotoView *photoView = [[CAPSPhotoView alloc] initWithFrame:CGRectMake(0, 0, 320, 568) dateTitle:@"Date: 03/12/2014" title:@"Title" subtitle:@"Subtitle"];
    [photoView fadeInPhotoViewFromImageView:self.imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
