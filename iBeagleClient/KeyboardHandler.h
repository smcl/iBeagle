//
//  KeyboardEventHandler.h
//  iBeagleClient
//
//  Created by Sean McLemon on 22/10/14.
//  Copyright (c) 2014 Sean McLemon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InputHandler.h"

@interface KeyboardHandler : InputHandler

@property (nonatomic, assign) id<BeagleConnection> beagle;
@property (nonatomic, weak) NSMutableDictionary *keyMap;

- (void)keyPress:(NSString*)key;
- (NSString*)uinputMap:(NSString*)keyCode;
    
@end
