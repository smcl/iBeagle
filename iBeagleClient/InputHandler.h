//
//  InputHandler.h
//  iBeagleClient
//
//  Created by Sean McLemon on 22/10/14.
//  Copyright (c) 2014 Sean McLemon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeagleConnection.h"

@interface InputHandler : NSObject

- (NSArray *)pressOnOff:(NSString*)eventName withDevice:(NSString*)dev;
- (NSDictionary *)press:(NSString*)eventName withDevice:(NSString*)dev withValue:(NSString*)val;

@end
