//
//  CAPSTableViewCell.h
//  CAPSPhotoViewTableViewExample
//
//  Created by Niklas Fahl on 4/22/14.
//  Copyright (c) 2014 CAPS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAPSPhotoView.h"

@interface CAPSTableViewCell : UITableViewCell
{
    __weak IBOutlet UIImageView *imageView;
}

@end
