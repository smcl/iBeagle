//
//  SettingsViewController.h
//  iBeagleClient
//
//  Created by Sean McLemon on 24/10/14.
//  Copyright (c) 2014 Sean McLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <NSNetServiceBrowserDelegate, NSNetServiceDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *servicesTable;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (strong, nonatomic) NSNetService *selectedBeagle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *connectingAnimate;

@end

static NSString *const beagleServiceType = @"_ibeagle._tcp";