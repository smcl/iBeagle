//
//  ViewController.m
//  iBeagleClient
//
//  Created by Sean McLemon on 22/09/14.
//  Copyright (c) 2014 Sean McLemon. All rights reserved.
//

#import "TouchViewController.h"
#import "GCDAsyncSocket.h"
#include <arpa/inet.h>

@interface TouchViewController ()
{
}
@end

@implementation TouchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (self.beagle == nil) {
        self.beagle = [[ManualBeagleConnection alloc] init];
    }
    
    self.mouse = [[MouseHandler alloc] init];
    self.mouse.beagle = self.beagle;
    self.mouse.view = self.view; // TODO: fix this. shouldn't need to pass in the view. refactor :(
    
    self.keyboard = [[KeyboardHandler alloc] init];
    self.keyboard.beagle = self.beagle;
    
    // Setup left click gesture
    UITapGestureRecognizer *leftClickGesture = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self.mouse action:@selector(leftClick:)];
    leftClickGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:leftClickGesture];

    // Setup right click gesture
    UITapGestureRecognizer *rightClickGesture = [[UITapGestureRecognizer alloc]
                                                      initWithTarget:self.mouse action:@selector(rightClick:)];
    rightClickGesture.numberOfTouchesRequired = 2;
    rightClickGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:rightClickGesture];
    
    // Setup mouse move gesture
    UIPanGestureRecognizer *moveGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.mouse action:@selector(mouseMove:)];
    moveGesture.minimumNumberOfTouches = 1;
    moveGesture.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:moveGesture];
    
    // Setup scroll wheel gesture
    UIPanGestureRecognizer *scrollGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.mouse action:@selector(mouseScroll:)];
    [scrollGesture setMinimumNumberOfTouches:2];
    [scrollGesture setMaximumNumberOfTouches:2];
    [scrollGesture setDelaysTouchesBegan:YES];
    [self.view addGestureRecognizer:scrollGesture];
    
    [self becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)returnToSettings:(id)sender {
    //ReturnToSettings
    [self resignFirstResponder];
    [self performSegueWithIdentifier: @"ReturnToSettings" sender: self];
}

// keyboard shit start
-(BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)hasText {
    return NO;
}

- (void)insertText:(NSString *)key {
    [self.keyboard keyPress:key];
}

- (void)deleteBackward {
    [self.keyboard keyPress:@"BACKSPACE"];
}

@end
