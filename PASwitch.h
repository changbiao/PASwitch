//
//  PASwitch.h
//  PASwitchProject
//
//  Created by Pierre Abi-aad on 28/10/2013.
//  Copyright (c) 2013 Pierre Abi-aad. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PASwitchChangeHandler)(BOOL on);

@interface PASwitch : UIControl

@property (nonatomic, getter=isOn)  BOOL on;
@property (nonatomic, copy)         PASwitchChangeHandler changeHandler;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end