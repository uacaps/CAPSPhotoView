//
//  PhotoView.m
//  TCSO-Public
//
//  Created by Niklas Fahl on 3/14/14.
//  Copyright (c) 2014 Center for Advanced Public Safety. All rights reserved.
//

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
    
    UITapGestureRecognizer *dimViewTouchGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHidePhotoDetailView)];
    [dimView addGestureRecognizer:dimViewTouchGesture];
    [dimViewTouchGesture setDelegate:self];
    
    UIPinchGestureRecognizer *imageViewPinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchToZoom:)];
    [imageView addGestureRecognizer:imageViewPinchGesture];
    [imageViewPinchGesture setDelegate:self];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGesture setDelaysTouchesBegan:TRUE];
    [panGesture setDelaysTouchesEnded:TRUE];
    [panGesture setCancelsTouchesInView:TRUE];
    [imageView addGestureRecognizer:panGesture];
    [panGesture setDelegate:self];
}

// Swipe photo up or down to close
- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         photoDetailView.alpha = 0;
                     }];
    
    CGPoint translation = [recognizer translationInView:recognizer.view];
    
    recognizer.view.center=CGPointMake(recognizer.view.center.x, recognizer.view.center.y+ translation.y);
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
    
    if(recognizer.state == UIGestureRecognizerStateEnded){
    
        if (imageView.frame.origin.y > -17 && imageView.frame.origin.y < 153) {
            [UIView beginAnimations:@"RIGHT-WITH-RIGHT" context:NULL];
            [UIView setAnimationDuration:0.2];
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:nil cache:YES];
            [UIView setAnimationBeginsFromCurrentState:YES];
            /* Reset the frame view size*/
            imageView.frame = CGRectMake(0, 53, 320, 427);
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

- (void)toggleStatusBar
{
    [[UIApplication sharedApplication] setStatusBarHidden:hidden];
    
    hidden = !hidden;
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
//        imageView.layer.borderWidth = 0.5;
//        imageView.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:65.0].CGColor;
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
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
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         [dimView setAlpha:1];
                         
                         [imageView setFrame:CGRectMake(0, 53, 320, 427)];
                     }];
    
    
    [self performSelector:@selector(showHidePhotoDetailView) withObject:nil afterDelay:0.4];
    [self performSelector:@selector(toggleStatusBar) withObject:nil afterDelay:0.25];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
