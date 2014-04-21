//
//  PhotoView.h
//  TCSO-Public
//
//  Created by Niklas Fahl on 3/14/14.
//
//  Copyright (c) 2012 The Board of Trustees of The University of Alabama
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions
//  are met:
//
//  1. Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer in the
//     documentation and/or other materials provided with the distribution.
//  3. Neither the name of the University nor the names of the contributors
//     may be used to endorse or promote products derived from this software
//     without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
//  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
//  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
//  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
//  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
//  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
//  STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
//  OF THE POSSIBILITY OF SUCH DAMAGE.

#import <UIKit/UIKit.h>

@interface CAPSPhotoView : UIView <UIGestureRecognizerDelegate, UIScrollViewDelegate>
{
    UIView *dimView;
    
    UIScrollView *imageScrollView;
    UIImageView *imageView;
    
    UIView *photoDetailView;
    UIView *photoDetailGestureView;
    UILabel *titleLabel;
    UILabel *subtitleLabel;
    UILabel *dateTitleLabel;
    UIButton *closeBtn;
    UIView *detailBackground;
    UIView *detailLine;
    
    UIImageView *startImageView;
    UIImage *photo;
    
    CGPoint photoOrigin;
    CGPoint photoViewImageOrigin;
    
    CGSize photoSize;
    CGSize photoViewImageSize;
    
    CGFloat startPhotoRadius;
    CGFloat deviceHeight;
    CGFloat deviceWidth;
    
    float maxScale;
    
    BOOL hidden;
    BOOL originalImageViewHidden;
    BOOL isModal;
}

- (id)initWithFrame:(CGRect)frame dateTitle:(NSString *)dateTitle title:(NSString *)title subtitle:(NSString *)subtitle;

- (void)fadeInPhotoViewFromImageView:(UIImageView *)imgView;

- (void)openPhotoViewAsModalWithImageView:(UIImageView *)imgView;

@end
