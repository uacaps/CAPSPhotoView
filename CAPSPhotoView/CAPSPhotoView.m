//
//  PhotoView.m
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

#import "CAPSPhotoView.h"

@implementation CAPSPhotoView

// Constructor for using UIImage to set image
- (id)initWithFrame:(CGRect)frame dateTitle:(NSString *)dateTitle title:(NSString *)title subtitle:(NSString *)subtitle
{
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CAPSPhotoView class]) owner:nil options:nil][0];
    
    if (self) {
        // Initialization code
        
        hidden = YES;
        originalImageViewHidden = YES;
        
        [self.dateTitleLabel setText:dateTitle];
        [self.titleLabel setText:title];
        [self.subtitleLabel setText:subtitle];
        
        [self buildGestureRecognizers];
        
        closeBtn.layer.cornerRadius = 3;
        closeBtn.clipsToBounds = YES;
        closeBtn.layer.borderWidth = 1.0;
        closeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        deviceWidth = screenRect.size.width;
        deviceHeight = screenRect.size.height;
    }
    
    return self;
}

- (void)buildGestureRecognizers
{
    UITapGestureRecognizer *imageSingleTapTouchGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHidePhotoDetailView)];
    imageSingleTapTouchGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:imageSingleTapTouchGesture];
    [imageSingleTapTouchGesture setDelegate:self];
    
    UITapGestureRecognizer *imageDoubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapToZoom:)];
    imageDoubleTapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:imageDoubleTapGesture];
    [imageDoubleTapGesture setDelegate:self];
    
    [imageSingleTapTouchGesture requireGestureRecognizerToFail:imageDoubleTapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGesture setDelaysTouchesBegan:TRUE];
    [panGesture setDelaysTouchesEnded:TRUE];
    [panGesture setCancelsTouchesInView:TRUE];
    [photoDetailView addGestureRecognizer:panGesture];
    [panGesture setDelegate:self];
    
//    [self addGestureRecognizer:imageScrollView.pinchGestureRecognizer];
//    [pinchRecognizer setDelegate:imageScrollView];
//
//    UIPanGestureRecognizer *panGesture2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    [panGesture2 setDelaysTouchesBegan:TRUE];
//    [panGesture2 setDelaysTouchesEnded:TRUE];
//    [panGesture2 setCancelsTouchesInView:TRUE];
//    [imageView addGestureRecognizer:panGesture2];
//    [panGesture2 setDelegate:self];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
    
    scrollView.bounces = YES;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (scale == 1.0) {
        scrollView.bounces = NO;
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             photoDetailView.alpha = 1;
                         }];
    }
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         photoDetailView.alpha = 0;
                     }];
}

- (void)handleDoubleTapToZoom:(UIPanGestureRecognizer*)recognizer
{
    if (imageView.frame.size.width > deviceWidth) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             [imageScrollView setZoomScale:1.0 animated:YES];
                             
                             // Show detail view
                             photoDetailView.alpha = 1;
                         }];
    } else {
        [UIView animateWithDuration:0.3
                         animations:^{
                             
                             CGFloat verticalScale = deviceHeight / imageView.frame.size.height;
                             CGFloat horizontalScale = deviceWidth / imageView.frame.size.width;
                             
                             // set scale to 2 if image already spans entire
                             if (verticalScale == 1.0 && horizontalScale == 1.0) {
                                 [imageScrollView setZoomScale:2.0 animated:YES];
                             } else if (horizontalScale == 1.0) {
                                 [imageScrollView setZoomScale:verticalScale animated:YES];
                             } else {
                                 [imageScrollView setZoomScale:horizontalScale animated:YES];
                             }
                             
                             // Hide detail view
                             photoDetailView.alpha = 0;
                         }];
    }
}

// Swipe photo up or down to close
- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         photoDetailView.alpha = 0;
                     }];
    
    CGPoint translation = [recognizer translationInView:imageView];
    
    imageView.center=CGPointMake(imageView.center.x, imageView.center.y+ translation.y);
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:imageView];
    
    // Fade on swipe up/down
    float rangeMax = 150.0;
    float startImageViewY = 284.0;
    dimView.alpha = (rangeMax - ABS(startImageViewY - imageView.center.y)) / rangeMax;
    
    // Close photo view or bounce back depending on how far picture got swiped up/down
    if(recognizer.state == UIGestureRecognizerStateEnded){
    
        if (imageView.frame.origin.y > photoViewImageOrigin.y - 100 && imageView.frame.origin.y < photoViewImageOrigin.y + 100) {
            [UIView beginAnimations:@"RIGHT-WITH-RIGHT" context:NULL];
            [UIView setAnimationDuration:0.2];
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:nil cache:YES];
            [UIView setAnimationBeginsFromCurrentState:YES];
            /* Reset the frame view size*/
            imageView.frame = CGRectMake(photoViewImageOrigin.x, photoViewImageOrigin.y, photoViewImageSize.width, photoViewImageSize.height);//CGRectMake(0, 0, deviceWidth, deviceHeight);
            [UIView setAnimationDelegate:self];
            /*  Call bounce animation method */
            [UIView setAnimationDidStopSelector:@selector(bounceBackToOrigin)];
            [UIView commitAnimations];
        } else {
            
            if (isModal) {
                
                CGFloat endY;
                
                if (imageView.frame.origin.y < photoViewImageOrigin.y - 100) {
                    endY = 0 - photoViewImageSize.height;
                } else {
                    endY = deviceHeight;
                }
                
                [UIView animateWithDuration:0.3
                                 animations:^{
                                     dimView.alpha = 0;
                                     imageView.frame = CGRectMake(imageView.frame.origin.x, endY, imageView.frame.size.width, imageView.frame.size.height);
                                 }];
            } else {
                photoDetailView.alpha = 0;
                
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
                animation.timingFunction = [CAMediaTimingFunction     functionWithName:kCAMediaTimingFunctionLinear];
                animation.fromValue = [NSNumber numberWithFloat:0.0f];
                animation.toValue = [NSNumber numberWithFloat:startPhotoRadius];
                animation.duration = 0.4;
                [imageView.layer setCornerRadius:startPhotoRadius];
                [imageView.layer addAnimation:animation forKey:@"cornerRadius"];
                
                [UIView animateWithDuration:0.4
                                 animations:^{
                                     dimView.alpha = 0;
                                     imageView.frame = CGRectMake(photoOrigin.x, photoOrigin.y, photoSize.width, photoSize.height);
                                 }];
                
                [self performSelector:@selector(toggleOriginalImageView) withObject:nil afterDelay:0.4];
            }
            
            [self performSelector:@selector(removeSelfFromSuperview) withObject:nil afterDelay:0.4];
            [self performSelector:@selector(toggleStatusBar) withObject:nil afterDelay:0.1];
        }
    }
}

- (void)bounceBackToOrigin
{
    CABasicAnimation *bounceAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    bounceAnimation.duration = 0.7;
    bounceAnimation.repeatCount = 0;
    bounceAnimation.autoreverses = YES;
    bounceAnimation.fillMode = kCAFillModeBackwards;
    bounceAnimation.removedOnCompletion = YES;
    bounceAnimation.additive = NO;
    [imageView.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
    
    [UIView animateWithDuration:0.1
                     animations:^{
                                    photoDetailView.alpha = 1;
                                    dimView.alpha = 1;
                                }];
}

- (void)showHidePhotoDetailView
{
    // Check if image needs to be zoomed out to original size
    if (imageView.frame.size.width > deviceWidth) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             [imageScrollView setZoomScale:1.0 animated:YES];
                             
                             photoDetailView.alpha = 1;
                         }];
    } else {
        // Show or hide detail view
        if (photoDetailView.alpha == 0) {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 photoDetailView.alpha = 1;
                             }];
        } else {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 photoDetailView.alpha = 0;
                             }];
        }
    }
}

- (void)removeSelfFromSuperview
{
    [self removeFromSuperview];
}

- (BOOL)prefersStatusBarHidden
{
    return hidden;
}

- (void)toggleStatusBar
{
    [[UIApplication sharedApplication] setStatusBarHidden:hidden];
    
    hidden = !hidden;
}

- (IBAction)tempCloseBtn:(id)sender
{
    if (isModal) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.frame = CGRectMake(self.frame.origin.x, deviceHeight, self.frame.size.width, self.frame.size.height);
                         }];
    } else {
        photoDetailView.alpha = 0;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        animation.timingFunction = [CAMediaTimingFunction     functionWithName:kCAMediaTimingFunctionLinear];
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat:startPhotoRadius];
        animation.duration = 0.4;
        [imageView.layer setCornerRadius:startPhotoRadius];
        [imageView.layer addAnimation:animation forKey:@"cornerRadius"];
        
        [UIView animateWithDuration:0.4
                         animations:^{
                             dimView.alpha = 0;
                             imageView.frame = CGRectMake(photoOrigin.x, photoOrigin.y, photoSize.width, photoSize.height);
                         }];
        
        [self performSelector:@selector(toggleOriginalImageView) withObject:nil afterDelay:0.4];
    }
    
    [self performSelector:@selector(removeSelfFromSuperview) withObject:nil afterDelay:0.4];
    [self performSelector:@selector(toggleStatusBar) withObject:nil afterDelay:0.1];
}

- (void)toggleOriginalImageView
{
    startImageView.hidden = originalImageViewHidden;
    
    originalImageViewHidden = !originalImageViewHidden;
}

- (void)setDimViewAlpha:(CGFloat)alpha
{
    [dimView setAlpha:alpha];
}

- (void)setPhotoDetailViewAlpha:(CGFloat)alpha
{
    [photoDetailView setAlpha:alpha];
}

- (void)setFrameForImage:(CGRect)frame
{
    [imageView setFrame:frame];
}

- (void)setImageInfoFromImageView:(UIImageView *)imgView
{
    // Get parameters from start image view
    photoOrigin = imgView.frame.origin;
    photoSize = imgView.frame.size;
    startPhotoRadius = imgView.layer.cornerRadius;
    photo = imgView.image;
    
    [imageView setImage:photo];
}

// Start showing Photoview
- (void)fadeInPhotoViewFromImageView:(UIImageView *)imgView
{
    // Set isModal flag to NO
    isModal = NO;
    
    // Use original image view to make effect of animation better by hiding it
    imgView.clipsToBounds = YES;
    startImageView = imgView;
    [self toggleOriginalImageView];
    
    [self setImageInfoFromImageView:startImageView];
    
    imageView.frame = startImageView.frame;
    
    // Set up image view if necessary for radius
    if (startPhotoRadius > 0) {
        imageView.layer.cornerRadius = startPhotoRadius;
    }
    
    imageView.clipsToBounds = YES;
    
    [dimView setAlpha:0];
    [photoDetailView setAlpha:0];
    
    [[[[UIApplication sharedApplication] windows] lastObject] addSubview:self];
    [[[[UIApplication sharedApplication] windows] lastObject] bringSubviewToFront:self];
    
    // Corner radius animation
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.timingFunction = [CAMediaTimingFunction     functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSNumber numberWithFloat:startPhotoRadius];
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    animation.duration = 0.4;
    [imageView.layer setCornerRadius:0.0];
    [imageView.layer addAnimation:animation forKey:@"cornerRadius"];
    
    
    // Calculate height for image in photo view
    float scale = deviceWidth / startImageView.image.size.width;
    int height = startImageView.image.size.height * scale;
    
    // Accomodate long pictures
    if (height > deviceHeight) { // height more than device height
        scale = deviceHeight / startImageView.image.size.height;
        photoViewImageSize.height = deviceHeight;
        photoViewImageSize.width = startImageView.image.size.width * scale;
        photoViewImageOrigin.x = (deviceWidth - photoViewImageSize.width) / 2;
        photoViewImageOrigin.y = 0;
    } else {
        photoViewImageSize.height = startImageView.image.size.height * scale;
        photoViewImageSize.width = deviceWidth;
        photoViewImageOrigin.x = 0;
        photoViewImageOrigin.y = (deviceHeight - photoViewImageSize.height) / 2;
    }
    
    // Photo enlarge animation
    [UIView animateWithDuration:0.4
                     animations:^{
                         [dimView setAlpha:1];
                         
                         [imageView setFrame:CGRectMake(photoViewImageOrigin.x, photoViewImageOrigin.y, photoViewImageSize.width, photoViewImageSize.height)];
                     }];

    // Default max scale
    maxScale = 4.0;
    
    // Set up scroll view
    imageScrollView.maximumZoomScale = maxScale;
    imageScrollView.contentSize = imageView.frame.size;
    imageScrollView.delegate = self;
    
    [self addGestureRecognizer:imageScrollView.pinchGestureRecognizer];
    
    [self performSelector:@selector(showHidePhotoDetailView) withObject:nil afterDelay:0.4];
    [self performSelector:@selector(toggleStatusBar) withObject:nil afterDelay:0.25];
}

- (void)openPhotoViewAsModalWithImageView:(UIImageView *)imgView
{
    // Set isModal flag to YES
    isModal = YES;
    
    // Use original image view to make effect of animation better by hiding it
    imgView.clipsToBounds = YES;
    startImageView = imgView;
    
    [self setImageInfoFromImageView:startImageView];

    CGRect oldFrame = self.frame;
    
    self.frame = CGRectMake(self.frame.origin.x, deviceHeight, self.frame.size.width, self.frame.size.height);
    
    [[[[UIApplication sharedApplication] windows] lastObject] addSubview:self];
    [[[[UIApplication sharedApplication] windows] lastObject] bringSubviewToFront:self];
    
    // Calculate height for image in photo view
    float scale = deviceWidth / startImageView.image.size.width;
    int height = startImageView.image.size.height * scale;
    
    // Accomodate long pictures
    if (height > deviceHeight) { // height more than device height
        scale = deviceHeight / startImageView.image.size.height;
        photoViewImageSize.height = deviceHeight;
        photoViewImageSize.width = startImageView.image.size.width * scale;
        photoViewImageOrigin.x = (deviceWidth - photoViewImageSize.width) / 2;
        photoViewImageOrigin.y = 0;
    } else {
        photoViewImageSize.height = startImageView.image.size.height * scale;
        photoViewImageSize.width = deviceWidth;
        photoViewImageOrigin.x = 0;
        photoViewImageOrigin.y = (deviceHeight - photoViewImageSize.height) / 2;
    }
    
    // Set image view frame
    [imageView setFrame:CGRectMake(photoViewImageOrigin.x, photoViewImageOrigin.y, photoViewImageSize.width, photoViewImageSize.height)];
    
    // Modal animation
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self setFrame:oldFrame];
                     }];
    
    // Default max scale
    maxScale = 4.0;
    
    // Set up scroll view
    imageScrollView.maximumZoomScale = maxScale;
    imageScrollView.contentSize = imageView.frame.size;
    imageScrollView.delegate = self;
    
    [self addGestureRecognizer:imageScrollView.pinchGestureRecognizer];
    
    [self performSelector:@selector(toggleStatusBar) withObject:nil afterDelay:0.25];
}

@end
