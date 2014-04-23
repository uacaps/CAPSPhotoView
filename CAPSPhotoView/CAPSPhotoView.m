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
    self = [super init];
	if (self != nil) {
        // Initialization code
        self.frame = frame;
        
        hidden = YES;
        originalImageViewHidden = YES;
        
        // Set up UI
        [self buildUI];
        
        [dateTitleLabel setText:dateTitle];
        [titleLabel setText:title];
        [subtitleLabel setText:subtitle];
        
        [self buildGestureRecognizers];
    }
    
    return self;
}

- (void)buildGestureRecognizers
{
    // Set up tap gestures for when detail view is shown
    UITapGestureRecognizer *imageSingleTapTouchGestureDetailView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHidePhotoDetailView)];
    imageSingleTapTouchGestureDetailView.numberOfTapsRequired = 1;
    [photoDetailGestureView addGestureRecognizer:imageSingleTapTouchGestureDetailView];
    [imageSingleTapTouchGestureDetailView setDelegate:self];
    
    UITapGestureRecognizer *imageDoubleTapGestureDetailView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapToZoom:)];
    imageDoubleTapGestureDetailView.numberOfTapsRequired = 2;
    [photoDetailGestureView addGestureRecognizer:imageDoubleTapGestureDetailView];
    [imageDoubleTapGestureDetailView setDelegate:self];
    
    [imageSingleTapTouchGestureDetailView requireGestureRecognizerToFail:imageDoubleTapGestureDetailView];
    
    // Set up tap gestures on image
    UITapGestureRecognizer *imageSingleTapTouchGestureImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHidePhotoDetailView)];
    imageSingleTapTouchGestureImage.numberOfTapsRequired = 1;
    [imageView addGestureRecognizer:imageSingleTapTouchGestureImage];
    [imageSingleTapTouchGestureImage setDelegate:self];
    
    UITapGestureRecognizer *imageDoubleTapGestureImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapToZoom:)];
    imageDoubleTapGestureImage.numberOfTapsRequired = 2;
    [imageView addGestureRecognizer:imageDoubleTapGestureImage];
    [imageDoubleTapGestureImage setDelegate:self];
    
    [imageSingleTapTouchGestureImage requireGestureRecognizerToFail:imageDoubleTapGestureImage];
    
    // Set up tap gestures on scrollview
    UITapGestureRecognizer *imageSingleTapTouchGestureScrollView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHidePhotoDetailView)];
    imageSingleTapTouchGestureScrollView.numberOfTapsRequired = 1;
    [imageScrollView addGestureRecognizer:imageSingleTapTouchGestureScrollView];
    [imageSingleTapTouchGestureScrollView setDelegate:self];
    
    UITapGestureRecognizer *imageDoubleTapGestureImageScrollView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapToZoom:)];
    imageDoubleTapGestureImageScrollView.numberOfTapsRequired = 2;
    [imageScrollView addGestureRecognizer:imageDoubleTapGestureImageScrollView];
    [imageDoubleTapGestureImageScrollView setDelegate:self];
    
    [imageSingleTapTouchGestureScrollView requireGestureRecognizerToFail:imageDoubleTapGestureImageScrollView];
    
    // Set up pan gesture for when detail view is present
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGesture setDelaysTouchesBegan:TRUE];
    [panGesture setDelaysTouchesEnded:TRUE];
    [panGesture setCancelsTouchesInView:TRUE];
    [photoDetailGestureView addGestureRecognizer:panGesture];
    [panGesture setDelegate:self];
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
        
        closeBtn.enabled = YES;
        [photoDetailView setUserInteractionEnabled:YES];
    } else {
        [UIView animateWithDuration:0.3
                         animations:^{
                             
                             CGFloat verticalScale = deviceHeight / imageView.frame.size.height;
                             CGFloat horizontalScale = deviceWidth / imageView.frame.size.width;
                             
                             // set scale to 2 if image already spans entire
                             if (verticalScale <= 1.0 && horizontalScale <= 1.0) {
                                 [imageScrollView setZoomScale:2.0 animated:YES];
                             } else if (horizontalScale <= 1.0) {
                                 [imageScrollView setZoomScale:verticalScale animated:YES];
                             } else {
                                 [imageScrollView setZoomScale:horizontalScale animated:YES];
                             }
                             
                             // Hide detail view
                             photoDetailView.alpha = 0;
                         }];
        closeBtn.enabled = NO;
        [photoDetailView setUserInteractionEnabled:NO];
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
    
    [self showStatusBar];// TEST
    
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
//            [self performSelector:@selector(toggleStatusBar) withObject:nil afterDelay:0.1];
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
    
    [self performSelector:@selector(hideStatusBar) withObject:nil afterDelay:0.1]; // TEST
}

- (void)showHidePhotoDetailView
{
    // Check if image needs to be zoomed out to original size
    if (imageView.frame.size.width > deviceWidth || (int)imageView.frame.size.height > deviceHeight) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             [imageScrollView setZoomScale:1.0 animated:YES];
                             
                             photoDetailView.alpha = 1;
                         }];
        
        closeBtn.enabled = YES;
        [photoDetailView setUserInteractionEnabled:YES];
    } else {
        // Show or hide detail view
        if (photoDetailView.alpha == 0) {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 photoDetailView.alpha = 1;
                             }];
            
            closeBtn.enabled = YES;
            [photoDetailView setUserInteractionEnabled:YES];
        } else {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 photoDetailView.alpha = 0;
                             }];
            
            closeBtn.enabled = NO;
            [photoDetailView setUserInteractionEnabled:NO];
        }
    }
}

- (void)removeSelfFromSuperview
{
    [self removeFromSuperview];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)hideStatusBar
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)showStatusBar
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)toggleStatusBar
{
    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationNone];
    
    hidden = !hidden;
}

- (void)tappedCloseButton
{
    closeBtn.enabled = NO;
    [photoDetailView setUserInteractionEnabled:NO];
    
    if (isModal) {
        photoDetailView.alpha = 0;
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             dimView.alpha = 0;
                             imageView.frame = CGRectMake(imageView.frame.origin.x, deviceHeight, imageView.frame.size.width, imageView.frame.size.height);
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
    // Translate image view origin to window
    CGPoint origin = [imgView.superview convertPoint:imgView.frame.origin toView:nil];
    
    // Set parameters from start image view
    photoOrigin = origin;
    photoSize = imgView.frame.size;
    startPhotoRadius = imgView.layer.cornerRadius;
    photo = imgView.image;
    
    [imageView setImage:photo];
}

// Start showing Photoview
- (void)fadeInPhotoViewFromImageView:(UIImageView *)imgView
{
    hidden = YES;
    
    // Set isModal flag to NO
    isModal = NO;
    
    closeBtn.enabled = YES;
    [photoDetailView setUserInteractionEnabled:YES];
    
    // Use original image view to make effect of animation better by hiding it
    imgView.clipsToBounds = YES;
    startImageView = imgView;
    [self toggleOriginalImageView];
    
    [self setImageInfoFromImageView:startImageView];
    
    imageView.frame = CGRectMake(photoOrigin.x, photoOrigin.y, photoSize.width, photoSize.height);
    
    // Set up image view if necessary for radius
    if (startPhotoRadius > 0) {
        imageView.layer.cornerRadius = startPhotoRadius;
    }
    
    imageView.clipsToBounds = YES;
    
    [dimView setAlpha:0];
    [photoDetailView setAlpha:0];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self];
    
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
    hidden = YES;
    
    // Set isModal flag to YES
    isModal = YES;
    
    closeBtn.enabled = YES;
    [photoDetailView setUserInteractionEnabled:YES];
    
    [dimView setAlpha:1];
    [photoDetailView setAlpha:1];
    
    // Use original image view to make effect of animation better by hiding it
    imgView.clipsToBounds = YES;
    startImageView = imgView;
    
    [self setImageInfoFromImageView:startImageView];
    
    imageView.layer.cornerRadius = startPhotoRadius;

    CGRect oldFrame = CGRectMake(0, 0, deviceWidth, deviceHeight);//self.frame;
    
    self.frame = CGRectMake(self.frame.origin.x, deviceHeight, self.frame.size.width, self.frame.size.height);
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self];
    
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

- (void)buildUI
{
    // Set device height and width variables
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    deviceWidth = screenRect.size.width;
    deviceHeight = screenRect.size.height;
    
    // Set up dim view
    dimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth, deviceHeight)];
    dimView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    dimView.backgroundColor = [UIColor blackColor];
    dimView.userInteractionEnabled = YES;
    dimView.alpha = 1;
    [self addSubview:dimView];
    
    // Set up scroll view
    imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth, deviceHeight)];
    imageScrollView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [imageScrollView setBounces:NO];
    [imageScrollView setShowsHorizontalScrollIndicator:NO];
    [imageScrollView setShowsVerticalScrollIndicator:NO];
    [imageScrollView setScrollEnabled:YES];
    imageScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:imageScrollView];
    
    // Set up image view adn add to scroll view
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth, deviceHeight)];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.backgroundColor = [UIColor clearColor];
    [imageScrollView addSubview:imageView];
    
    // Set up detail view
    photoDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth, deviceHeight)];
    photoDetailView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    photoDetailView.backgroundColor = [UIColor clearColor];
    photoDetailView.userInteractionEnabled = YES;
    [photoDetailView setContentMode:UIViewContentModeScaleToFill];
    [self addSubview:photoDetailView];
    
    // Set up detail view components
    photoDetailGestureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth, deviceHeight)];
    photoDetailGestureView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    photoDetailGestureView.backgroundColor = [UIColor clearColor];
    photoDetailGestureView.userInteractionEnabled = YES;
    [photoDetailView addSubview:photoDetailGestureView];
    
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(253, 11, 57, 27);
    closeBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    closeBtn.backgroundColor = [UIColor colorWithRed:23.0/255.0 green:23.0/255.0 blue:23.0/255.0 alpha:0.65];
    closeBtn.layer.cornerRadius = 3;
    closeBtn.clipsToBounds = YES;
    closeBtn.layer.borderWidth = 1.0;
    closeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    closeBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
    [closeBtn setTitle:@"Done" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(tappedCloseButton) forControlEvents:UIControlEventTouchUpInside];
    [photoDetailView addSubview:closeBtn];
    
    detailBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 482, 320, 86)];
    detailBackground.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    detailBackground.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
    [photoDetailView addSubview:detailBackground];
    
    detailLine = [[UIView alloc] initWithFrame:CGRectMake(10, 509, 300, 1)];
    detailLine.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    detailLine.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.4];
    [photoDetailView addSubview:detailLine];
    
    dateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(211, 484, 99, 21)];
    dateTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    dateTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:13.0f];
    dateTitleLabel.backgroundColor = [UIColor clearColor];
    dateTitleLabel.textColor = [UIColor whiteColor];
    dateTitleLabel.textAlignment = NSTextAlignmentRight;
    [photoDetailView addSubview:dateTitleLabel];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 513, 300, 25)];
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:19.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [photoDetailView addSubview:titleLabel];
    
    subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 539, 300, 21)];
    subtitleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    subtitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
    subtitleLabel.backgroundColor = [UIColor clearColor];
    subtitleLabel.textColor = [UIColor whiteColor];
    subtitleLabel.textAlignment = NSTextAlignmentLeft;
    [photoDetailView addSubview:subtitleLabel];
}

@end
