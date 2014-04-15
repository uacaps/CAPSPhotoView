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
    }
    
    return self;
}

- (void)buildGestureRecognizers
{
    UITapGestureRecognizer *PhotoDetailViewTouchGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePhotoDetailView)];
    [photoDetailView addGestureRecognizer:PhotoDetailViewTouchGesture];
    [PhotoDetailViewTouchGesture setDelegate:self];
    
    UITapGestureRecognizer *imageViewTouchGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHidePhotoDetailView)];
    [imageView addGestureRecognizer:imageViewTouchGesture];
    [imageViewTouchGesture setDelegate:self];
    
//    UITapGestureRecognizer *dimViewTouchGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHidePhotoDetailView)];
//    [dimView addGestureRecognizer:dimViewTouchGesture];
//    [dimViewTouchGesture setDelegate:self];
    
    UIPinchGestureRecognizer *imageViewPinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchToZoom:)];
    [photoDetailView addGestureRecognizer:imageViewPinchGesture];
    [imageViewPinchGesture setDelegate:self];
    
    UIPinchGestureRecognizer *imageViewPinchGesture2 = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchToZoom:)];
    [imageView addGestureRecognizer:imageViewPinchGesture2];
    [imageViewPinchGesture2 setDelegate:self];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGesture setDelaysTouchesBegan:TRUE];
    [panGesture setDelaysTouchesEnded:TRUE];
    [panGesture setCancelsTouchesInView:TRUE];
    [photoDetailView addGestureRecognizer:panGesture];
    [panGesture setDelegate:self];
    
    UIPanGestureRecognizer *panGesture2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGesture2 setDelaysTouchesBegan:TRUE];
    [panGesture2 setDelaysTouchesEnded:TRUE];
    [panGesture2 setCancelsTouchesInView:TRUE];
    [imageView addGestureRecognizer:panGesture2];
    [panGesture2 setDelegate:self];
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
    NSLog(@"Alpha is: %f at Y: %f", dimView.alpha, imageView.center.y);
    
    // Close photo view or bounce back depending on how far picture got swiped up/down
    if(recognizer.state == UIGestureRecognizerStateEnded){
    
        if (imageView.frame.origin.y > -47 && imageView.frame.origin.y < 153) {
            [UIView beginAnimations:@"RIGHT-WITH-RIGHT" context:NULL];
            [UIView setAnimationDuration:0.2];
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:nil cache:YES];
            [UIView setAnimationBeginsFromCurrentState:YES];
            /* Reset the frame view size*/
            imageView.frame = CGRectMake(0, 0, 320, 568);
            [UIView setAnimationDelegate:self];
            /*  Call bounce animation method */
            [UIView setAnimationDidStopSelector:@selector(bounceBackToOrigin)];
            [UIView commitAnimations];
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
                                 imageView.contentMode = UIViewContentModeScaleAspectFill;
                             }];
            
            [self performSelector:@selector(toggleOriginalImageView) withObject:nil afterDelay:0.4];
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
    
    [UIView animateWithDuration:0.3
                     animations:^{
                                    photoDetailView.alpha = 1;
                                    dimView.alpha = 1;
                                }];
}

- (void)pinchToZoom:(UIPinchGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded
        || recognizer.state == UIGestureRecognizerStateChanged) {
        
        [UIView animateWithDuration:0.1
                         animations:^{
                             photoDetailView.alpha = 0;
                         }];
        
        CGFloat currentScale = imageView.frame.size.width / imageView.bounds.size.width;
        CGFloat newScale = currentScale * recognizer.scale;
        
        if (newScale < 0.3) {
            newScale = 0.3;
        }
        if (newScale > 3.5) {
            newScale = 3.5;
        }
        
        CGAffineTransform transform = CGAffineTransformMakeScale(newScale, newScale);
        imageView.transform = transform;
        recognizer.scale = 1;
        
        if ([recognizer state] == UIGestureRecognizerStateEnded) {
            if (newScale < 1.0) {
                [UIView animateWithDuration:0.3
                                 animations:^{
                                     CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 1.0);
                                     imageView.transform = transform;
                                     recognizer.scale = 1;
                                 }];
                
                [self performSelector:@selector(showHidePhotoDetailView) withObject:nil afterDelay:0.4];
            }
        }
    }
}

- (void)hidePhotoDetailView
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         photoDetailView.alpha = 0;
                     }];
}

- (void)transformImageViewToOriginal
{
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 1.0);
    imageView.transform = transform;
}

- (void)showHidePhotoDetailView
{
    // check if image needs to be zoomed out to original size
    if (imageView.frame.size.width > 320) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self transformImageViewToOriginal];
                         }];
        [self performSelector:@selector(showHidePhotoDetailView) withObject:nil afterDelay:0.4];
    } else {
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
    
//    [UIView animateWithDuration:1.0 animations:^{
//        hidden = !hidden;
//        [[UIApplication sharedApplication] setNeedsStatusBarAppearanceUpdate];
//    }];
}

- (IBAction)tempCloseBtn:(id)sender
{
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
                                imageView.contentMode = UIViewContentModeScaleAspectFill;
                          }];
    
    [self performSelector:@selector(toggleOriginalImageView) withObject:nil afterDelay:0.4];
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
    // Use original image view to make effect of animation better by hiding it
    startImageView = imgView;
    [self toggleOriginalImageView];
    
    [self setImageInfoFromImageView:startImageView];
    
    [imageView setFrame:CGRectMake(photoOrigin.x, photoOrigin.y, photoSize.width, photoSize.height)];
    
    // Set up image view if necessary for radius
    if (startPhotoRadius > 0) {
        imageView.layer.cornerRadius = startPhotoRadius;
        imageView.clipsToBounds = YES;
        
    }
    
    [dimView setAlpha:0];
    [photoDetailView setAlpha:0];
    
    [[[[UIApplication sharedApplication] windows] lastObject] addSubview:self];
    [[[[UIApplication sharedApplication] windows] lastObject] bringSubviewToFront:self];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.timingFunction = [CAMediaTimingFunction     functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSNumber numberWithFloat:startPhotoRadius];
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    animation.duration = 0.4;
    [imageView.layer setCornerRadius:0.0];
    [imageView.layer addAnimation:animation forKey:@"cornerRadius"];
    
//    [UIView animateWithDuration:0.4
//                     animations:^{
//                         [dimView setAlpha:1];
//                         [imageView setFrame:CGRectMake(0, 0, 320, 568)];
//                     }];
    
    
    [self performSelector:@selector(showHidePhotoDetailView) withObject:nil afterDelay:0.4];
    [self performSelector:@selector(toggleStatusBar) withObject:nil afterDelay:0.25];
}

@end
