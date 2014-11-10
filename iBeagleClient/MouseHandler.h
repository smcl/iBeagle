//
//  MouseEventHandler.h
//  iBeagleClient
//
//  Created by Sean McLemon on 21/10/14.
//  Copyright (c) 2014 Sean McLemon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InputHandler.h"

@interface MouseHandler : InputHandler

- (void)leftClick:(UIGestureRecognizer *)sender;
- (void)rightClick:(UIGestureRecognizer *)sender;
- (void)mouseMove:(UIGestureRecognizer *)sender;
- (void)mouseScroll:(UIGestureRecognizer *)sender;

@property (nonatomic, assign) id<BeagleConnection> beagle;
@property (nonatomic, assign) UIView *view;  //TEMP: hack to get the current location in the view;
@property (nonatomic, assign) CGPoint previousPanLocation;
@property (nonatomic, assign) NSUInteger currentPanType;

@end

