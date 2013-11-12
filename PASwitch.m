//
//  PASwitch.m
//  PASwitchProject
//
//  Created by Pierre Abi-aad on 28/10/2013.
//  Copyright (c) 2013 Pierre Abi-aad. All rights reserved.
//

#import "PASwitch.h"
#import <QuartzCore/QuartzCore.h>

#define kWidth  56.f
#define kHeight 31.f

#define kOnColor  [UIColor colorWithRed:(89.f/255.f) green:(200.f/255.f) blue:(147.f/255.f) alpha:1.f].CGColor
#define kOffColor [UIColor colorWithRed:(239.f/255.f) green:(239.f/255.f) blue:(239.f/255.f) alpha:1.f].CGColor

@interface PASwitch ()

@property (nonatomic, strong) CAShapeLayer  *shapeLayer;
@property (nonatomic, strong) UIImageView   *onView;
@property (nonatomic, strong) UIImageView   *offView;
@property (nonatomic, assign) BOOL          animating;

@end

@implementation PASwitch

- (id)initWithFrame:(CGRect)frame
{
    frame.size.width = kWidth;
    frame.size.height = kHeight;
    
    self = [super initWithFrame:frame];
    if (self) {
        _on = YES;
        _animating = NO;
        self.backgroundColor = [UIColor clearColor];
        
        _onView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"onCursor.png"]];
        _offView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"offCursor.png"]];
        _offView.alpha = 0.f;

        CGRect onFrame = _onView.frame;
        onFrame.origin.x = frame.size.width - onFrame.size.width - 3;
        onFrame.origin.y = 3;
        _onView.frame = onFrame;
        
        CGRect offFrame = _offView.frame;
        offFrame.origin.x = 3;
        offFrame.origin.y = 3;
        _offView.frame = offFrame;

        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) cornerRadius:4].CGPath;
        _shapeLayer.fillColor = (_on) ? kOnColor : kOffColor;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [panGestureRecognizer setMinimumNumberOfTouches:1];
        [self addGestureRecognizer:panGestureRecognizer];
        
        [self.layer addSublayer:_shapeLayer];
        [self addSubview:_onView];
        [self addSubview:_offView];
    }
    return self;
}

- (void)setOn:(BOOL)on {
    [self setOn:on animated:NO sendActions:NO];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
     [self setOn:on animated:animated sendActions:NO];
}

- (void)handleTapGesture:(UIGestureRecognizer *)gesture {
    [self setOn:!_on animated:YES sendActions:YES];
}

- (void)handlePanGesture:(UIGestureRecognizer *)gesture {
    [self setOn:!_on animated:YES sendActions:YES];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated sendActions:(BOOL)sendActions {
    if(_animating) return;
    
    if (_on != on) {
        _on = on;
        _animating = YES;
        
        CABasicAnimation *fillColorAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
        fillColorAnimation.duration =(animated ? 0.4f : 0.f);
        fillColorAnimation.fromValue = (id)((_on) ? kOffColor : kOnColor);
        fillColorAnimation.toValue = (id)((_on) ? kOnColor : kOffColor);
        fillColorAnimation.repeatCount = 0;
        fillColorAnimation.fillMode = kCAFillModeForwards;
        fillColorAnimation.removedOnCompletion = NO;
        [_shapeLayer addAnimation:fillColorAnimation forKey:@"fillColor"];
        
        UIImageView *oldView = (_on) ? _offView : _onView;
        UIImageView *newView = (_on) ? _onView : _offView;
        
        CGRect frame = oldView.frame;
        frame.origin.x = (_on) ? 3 : (self.frame.size.width - frame.size.width - 3);
        
        [UIView animateWithDuration:(animated ? 0.2f : 0.f)
                         animations:^{oldView.frame = newView.frame;}
                         completion:^(BOOL finished)
        {
            [UIView animateWithDuration:(animated ? 0.2f : 0.f)
                             animations:^{
                                 oldView.alpha = 0.f;
                                 newView.alpha = 1.f;}
                             completion:^(BOOL finished) {
                                 oldView.frame = frame;
                                 _animating = NO;
                                 if(sendActions) {
                                     if(self.changeHandler) self.changeHandler(_on);
                                     [self
                                      sendActionsForControlEvents:UIControlEventValueChanged];
                                 }
                             }];
        }];
    }
}

@end