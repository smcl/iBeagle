//
//  MouseEventHandler.m
//  iBeagleClient
//
//  Created by Sean McLemon on 21/10/14.
//  Copyright (c) 2014 Sean McLemon. All rights reserved.
//

#import "MouseHandler.h"

@implementation MouseHandler 

- (id)init {
    self = [super init];

    self.currentPanType = 0;
    
    return self;
}

// gesture shit
- (void)leftClick:(UIGestureRecognizer *)sender
{
    NSArray *click = [self pressOnOff:@"BTN_LEFT" withDevice:@"mouse"];
    [self.beagle sendInputToBeagle:click];
}

- (void)rightClick:(UIGestureRecognizer *)sender
{
    NSArray *click = [self pressOnOff:@"BTN_RIGHT" withDevice:@"mouse"];
    [self.beagle sendInputToBeagle:click];
}

-(void)mouseMove:(UIPanGestureRecognizer *)sender{
    // UIPanGestureRecognizer has no "previous" location, so need to track separately
    if (self.currentPanType != sender.numberOfTouches || sender.state == UIGestureRecognizerStateBegan) {
        self.currentPanType = sender.numberOfTouches;
        self.previousPanLocation = [sender locationInView:self.view];
        return;
    }
    
    // calculate x/y panning deltas
    CGPoint currentPanLocation = [sender locationInView:self.view];
    int deltax = currentPanLocation.x - self.previousPanLocation.x;
    int deltay = currentPanLocation.y - self.previousPanLocation.y;
    
    // create the pan event and send
    NSMutableArray *pan = [[NSMutableArray alloc] init];
    
    if (deltax != 0) {
        [pan addObject:[self press:@"REL_X" withDevice:@"mouse" withValue:[NSString stringWithFormat:@"%d", deltax]]];
    }
    
    if (deltay != 0) {
        [pan addObject:[self press:@"REL_Y" withDevice:@"mouse" withValue:[NSString stringWithFormat:@"%d", deltay]]];
    }
    
    [self.beagle sendInputToBeagle:pan];
    
    // update previousPanLocation
    self.previousPanLocation = currentPanLocation;
}

-(void)mouseScroll:(UIPanGestureRecognizer *)sender{
    // UIPanGestureRecognizer has no "previous" location, so need to track separately
    if (self.currentPanType != sender.numberOfTouches || sender.state == UIGestureRecognizerStateBegan) {
        self.currentPanType = sender.numberOfTouches;
        self.previousPanLocation = [sender locationInView:self.view];
        return;
    }
    
    // calculate x/y panning deltas
    CGPoint currentPanLocation = [sender locationInView:self.view];
    int deltay = -(currentPanLocation.y - self.previousPanLocation.y);
    
    // now create and send a "REL_WHEEL" event
    NSMutableArray *pan = [[NSMutableArray alloc] init];
    
    if (deltay != 0) {
        [pan addObject:[self press:@"REL_WHEEL" withDevice:@"mouse" withValue:[NSString stringWithFormat:@"%d", deltay]]];
    }
    
    [self.beagle sendInputToBeagle:pan];
    
    // update previousPanLocation
    self.previousPanLocation = currentPanLocation;
}

@end
