//
//  PhotoView.h
//  TCSO-Public
//
//  Created by Niklas Fahl on 3/14/14.
//  Copyright (c) 2014 Center for Advanced Public Safety. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAPSPhotoView : UIView <UIGestureRecognizerDelegate>
{
    __weak IBOutlet UIImageView *imageView;
    
    __weak IBOutlet UIView *dimView;
    
    __weak IBOutlet UIView *photoDetailView;
    
    __weak IBOutlet UIButton *closeBtn;
    
    CGPoint photoOrigin;
    
    CGSize photoSize;
    
    CGFloat startPhotoRadius;
    
    NSString *photoID;
    
    BOOL hidden;
    
    BOOL originalImageViewHidden;
    
    UIImageView *startImageView;
    
    UIImage *photo;
}

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *subtitleLabel;
@property (weak, nonatomic) UILabel *dateTitleLabel;

- (void)setDimViewAlpha:(CGFloat)alpha;

- (void)setPhotoDetailViewAlpha:(CGFloat)alpha;

- (void)setFrameForImage:(CGRect)frame;

- (void)fadeInPhotoViewFromImageView:(UIImageView *)imgView;

- (id)initWithFrame:(CGRect)frame dateTitle:(NSString *)dateTitle title:(NSString *)title subtitle:(NSString *)subtitle;

- (IBAction)tempCloseBtn:(id)sender;

@end
