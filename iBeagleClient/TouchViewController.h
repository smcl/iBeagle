//
//  ViewController.h
//  iBeagleClient
//
//  Created by Sean McLemon on 22/09/14.
//  Copyright (c) 2014 Sean McLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MouseHandler.h"
#import "KeyboardHandler.h"
#import "ManualBeagleConnection.h"

@interface TouchViewController : UIViewController <UIKeyInput>
{

}

// commented out for now.
//@property (nonatomic,strong)id<BeagleConnection> beagle;
@property (nonatomic,strong)ManualBeagleConnection *beagle;
@property (nonatomic,strong)MouseHandler *mouse;
@property (nonatomic,strong)KeyboardHandler *keyboard;

@property (nonatomic,strong)NSInputStream *istream;
@property (nonatomic,strong)NSOutputStream *ostream;


@property (weak, nonatomic) IBOutlet UIButton *backButton;


@end

