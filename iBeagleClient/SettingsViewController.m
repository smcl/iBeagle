//
//  SettingsViewController.m
//  iBeagleClient
//
//  Created by Sean McLemon on 24/10/14.
//  Copyright (c) 2014 Sean McLemon. All rights reserved.
//

#import "SettingsViewController.h"
#import "TouchViewController.h"
#import "ManualBeagleConnection.h"

@interface SettingsViewController ()
{
    NSNetServiceBrowser *beagleBrowser;
    NSMutableArray *beagleServices;
}
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.connectingAnimate setHidden:true];
    
    // TEST: service discovery via bonjour
    beagleBrowser = [[NSNetServiceBrowser alloc] init];
    [beagleBrowser setDelegate:self];
    [beagleBrowser searchForServicesOfType:beagleServiceType inDomain:@""];
    beagleServices = [NSMutableArray arrayWithCapacity: 0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSNetService *service = [beagleServices objectAtIndex:indexPath.row];
    cell.textLabel.text = service.name;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return beagleServices.count;
}

- (IBAction)connectToService:(id)sender {
    id selectedIndexPath = [self.servicesTable indexPathForSelectedRow];
    
    if (selectedIndexPath != nil) {
        NSLog(@"%@", [self.servicesTable indexPathForSelectedRow]);
        
        NSInteger selectedIndex = [self.servicesTable indexPathForSelectedRow].row;
        NSNetService* beagle = [beagleServices objectAtIndex:selectedIndex];
        [beagle setDelegate:self];
        [beagle resolveWithTimeout:5];
        [self.connectingAnimate startAnimating];
        [self.connectingAnimate setHidden:false];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ResolvedServiceSegue"]) {
        TouchViewController* touchView = [segue destinationViewController];      
        touchView.beagle = [[ManualBeagleConnection alloc] initWithHostname:self.selectedBeagle.hostName withPort:self.selectedBeagle.port];
    }
}

// begin service browsing //////////////////////////////
- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)browser
{
    NSLog(@"searching ...");
}

// Sent when browsing stops
- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)browser
{
    NSLog(@"stopped searching.");
}

// Sent if browsing fails
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
             didNotSearch:(NSDictionary *)errorDict
{
    NSLog(@"error: %@", [errorDict objectForKey:NSNetServicesErrorCode]);
}

// Sent when a service appears
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
           didFindService:(NSNetService *)aNetService
               moreComing:(BOOL)moreComing
{
    [beagleServices addObject:aNetService];
    NSLog(@"Got service %p with name %@\n", aNetService,
          aNetService.name);
    
    if(!moreComing)
    {
        NSLog(@"No more services to add this time :)");
    }
    
    [self.servicesTable reloadData];
}

// Sent when a service disappears
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
         didRemoveService:(NSNetService *)aNetService
               moreComing:(BOOL)moreComing
{
    [beagleServices removeObject:aNetService];
    NSLog(@"Remove service %p with name %@", aNetService, aNetService.name);
    
    
    if(!moreComing)
    {
        NSLog(@"No more services to remove this time :)");
    }
    
    [self.servicesTable reloadData];
}
// service browsing end ///////////////////////

// service resolution succeeded
- (void)netServiceDidResolveAddress:(NSNetService *)netService
{
    NSLog(@"resolved service: %@ %ld", [netService hostName], (long)netService.port);
    self.selectedBeagle = netService;
    [self.connectingAnimate stopAnimating];
    [self.connectingAnimate setHidden:true];
  
// below commented code pulls streams from the bonjour service. originally
// intended to use this but GCDAsyncSocket handles all the multi-threading
// through GCD and is neater.
//    [self.selectedBeagle getInputStream:&istream outputStream:&ostream];
//    if (istream && ostream)
//    {
//        NSString *test = @"test";
//        NSData *data = [test dataUsingEncoding:NSUTF8StringEncoding];
//        [ostream open];
//        [ostream write:[data bytes] maxLength:[data length]];
//    }
//    else
//    {
//        NSLog(@"Failed to acquire valid streams");
//    }

    [self performSegueWithIdentifier: @"ResolvedServiceSegue" sender: self];
}

// service resolution failed - don't segue to the view (not sure what to do for now)
- (void)netService:(NSNetService *)netService
     didNotResolve:(NSDictionary *)errorDict
{
    [self.connectingAnimate stopAnimating];
    [self.connectingAnimate setHidden:true];
    NSLog(@"didn't resolve: %@", [errorDict objectForKey:NSNetServicesErrorCode]);
}

@end
