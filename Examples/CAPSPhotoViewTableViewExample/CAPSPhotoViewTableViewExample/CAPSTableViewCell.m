//
//  CAPSTableViewCell.m
//  CAPSPhotoViewTableViewExample
//
//  Created by Niklas Fahl on 4/22/14.
//  Copyright (c) 2014 CAPS. All rights reserved.
//

#import "CAPSTableViewCell.h"

@implementation CAPSTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CAPSTableViewCell class]) owner:nil options:nil][0];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
