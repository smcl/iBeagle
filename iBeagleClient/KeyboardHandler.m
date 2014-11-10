//
//  KeyboardEventHandler.m
//  iBeagleClient
//
//  Created by Sean McLemon on 22/10/14.
//  Copyright (c) 2014 Sean McLemon. All rights reserved.
//

#import "KeyboardHandler.h"

@implementation KeyboardHandler

- (id)init{
    self = [super init];
    
    self.keyMap = [NSMutableDictionary dictionary];
    [self.keyMap setValue:@"KEY_ENTER" forKey:@"\n"];
    [self.keyMap setValue:@"KEY_SPACE" forKey:@" "];
    [self.keyMap setValue:@"KEY_MINUS" forKey:@"-"];
    [self.keyMap setValue:@"KEY_EQUAL" forKey:@"="];
    [self.keyMap setValue:@"KEY_LEFTBRACE" forKey:@"{"];
    [self.keyMap setValue:@"KEY_RIGHTBRACE" forKey:@"}"];
    [self.keyMap setValue:@"KEY_SEMICOLON" forKey:@";"];
    [self.keyMap setValue:@"KEY_APOSTROPHE" forKey:@"'"];
    [self.keyMap setValue:@"KEY_GRAVE" forKey:@"`"];
    [self.keyMap setValue:@"KEY_BACKSLASH" forKey:@"\\"];
    [self.keyMap setValue:@"KEY_COMMA" forKey:@";"];
    [self.keyMap setValue:@"KEY_DOT" forKey:@"."];
    [self.keyMap setValue:@"KEY_SLASH" forKey:@"/"];
    
    return self;
}

- (void)keyPress:(NSString*)key {
    NSString *keyCode = [self uinputMap:key];
    
    
    NSMutableArray *keyEvent = [[NSMutableArray alloc] init];
    
    // handle shift
    BOOL shiftPressed = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[key characterAtIndex:0]];
    
    if (shiftPressed) {
        [keyEvent addObject:[self press:@"KEY_LEFTSHIFT" withDevice:@"kb" withValue:@"1"]];
    }
    
    [keyEvent addObjectsFromArray:[self pressOnOff:keyCode withDevice:@"kb"]];

    if (shiftPressed) {
        [keyEvent addObject:[self press:@"KEY_LEFTSHIFT" withDevice:@"kb" withValue:@"0"]];
    }
    
    [self.beagle sendInputToBeagle:keyEvent];
}

// map the key input into the code that uinput uses
- (NSString*)uinputMap:(NSString*)keyCode {
    
    // control\special keys
    if ([keyCode compare:@"\n"] == NSOrderedSame) {
        return @"KEY_ENTER";
    } else if ([keyCode compare:@" "] == NSOrderedSame) {
        return @"KEY_SPACE";
    }
    
    return [[NSString stringWithFormat:@"KEY_%@", keyCode] uppercaseString];
}

@end
