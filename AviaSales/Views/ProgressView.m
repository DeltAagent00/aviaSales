//
//  ProgressView.m
//  AviaSales
//
//  Created by Alex on 04/01/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

#import "ProgressView.h"

#define SIZE_PLANE 50.0

@implementation ProgressView

BOOL isActive;

+(instancetype)sharedInstance {
    static ProgressView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ProgressView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        [instance setup];
    });
    return instance;
}

-(void)setup {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    backgroundImageView.image = [UIImage imageNamed:@"cloud"];
    backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    backgroundImageView.clipsToBounds = YES;
    [self addSubview:backgroundImageView];
    
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
    blurView.frame = self.bounds;
    [self addSubview:blurView];
    
    [self createPlanes];
}

-(void)createPlanes {
    for (int i = 1; i < 6; ++i) {
        UIImageView *plane = [[UIImageView alloc] initWithFrame:CGRectMake(-SIZE_PLANE, ((float)i * SIZE_PLANE) + 100.0, SIZE_PLANE, SIZE_PLANE)];
        plane.tag = i;
        plane.image = [UIImage imageNamed:@"plane"];
        [self addSubview:plane];
    }
}

-(void)startAnimating:(NSInteger)planeId {
    if (!isActive) {
        return;
    }
    
    if (planeId >= 6) {
        planeId = 1;
    }
    
    UIImageView *plane = [self viewWithTag:planeId];
    
    if (plane) {
        [UIView animateWithDuration:1.0 animations:^{
            plane.frame = CGRectMake(self.bounds.size.width, plane.frame.origin.y, SIZE_PLANE, SIZE_PLANE);
        } completion:^(BOOL finished) {
            plane.frame = CGRectMake(-SIZE_PLANE, plane.frame.origin.y, SIZE_PLANE, SIZE_PLANE);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startAnimating:planeId + 1];
        });
    }
}

-(void)show:(void (^)(void))completion {
    self.alpha = 0.0;
    isActive = YES;
    [self startAnimating: 1];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0;
    }completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

-(void)dismiss:(void (^)(void))completion {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        isActive = NO;
        if (completion) {
            completion();
        }
    }];
}

@end
