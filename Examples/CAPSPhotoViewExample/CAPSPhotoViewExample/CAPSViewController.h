//
//  CAPSViewController.h
//  CAPSPhotoViewExample
//
//  Created by Niklas Fahl on 4/14/14.
//  Copyright (c) 2014 CAPS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAPSPhotoView.h"

@interface CAPSViewController : UIViewController
{
    CAPSPhotoView *photoView;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;

@end
