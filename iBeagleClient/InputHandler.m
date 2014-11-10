//
//  InputHandler.m
//  iBeagleClient
//
//  Created by Sean McLemon on 22/10/14.
//  Copyright (c) 2014 Sean McLemon. All rights reserved.
//

#import "InputHandler.h"

@implementation InputHandler

- (NSArray *)pressOnOff:(NSString*)eventName withDevice:(NSString*)dev
{
    NSMutableArray *keyPress = [[NSMutableArray alloc] init];
    
    [keyPress addObject:[self press:eventName withDevice:dev withValue:@"1"]];
    [keyPress addObject:[self press:eventName withDevice:dev withValue:@"0"]];
    
    return keyPress;
}

- (NSDictionary *)press:(NSString*)eventName withDevice:(NSString*)dev withValue:(NSString*)val
{
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    
    [event setObject:dev forKey:@"dev"];
    [event setObject:eventName forKey:@"event"];
    [event setObject:val forKey:@"value"];
    
    return event;
}

@end
