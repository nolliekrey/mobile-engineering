//
//  ECTableViewController.m
//  ExistingCommunal
//
//  Created by Jon Whitmore on 5/3/14.
//  Copyright (c) 2014 Jon Whitmore. All rights reserved.
//

#import "ECTableViewController.h"
#import "ECDealTableViewCell.h"
#import "ECDeal.h"
#import "ECUser.h"
#import "ECAvatar.h"
#import <QuartzCore/QuartzCore.h>

@interface ECTableViewController ()
// Fetches JSON data from the server and parses it
- (void)fetchData;

// Action triggered when the deal's image is clicked
- (IBAction)triggerDealImageActionWithSender:(id)sender;

// Collection of Existing Communal deals downloaded from kECDealJSONURL
@property (nonatomic, strong) NSMutableArray *deals;

// Background work/downloading indicator
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

// The URL string that will be used to fetch data from the server
NSString * const kECDealJSONURL = @"http://sheltered-bastion-2512.herokuapp.com/feed.json";

@implementation ECTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Make the navigation bar a nice purple
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:109/255.0f green:79/255.0f blue:171/255.0f alpha:1.0f];
    // with white text
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    _deals = [[NSMutableArray alloc] init];
    [self fetchData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)fetchData
{
    if (!self.spinner) {
        self.spinner = [[UIActivityIndicatorView alloc]
                                            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.spinner.center = CGPointMake(160, 240);
        self.spinner.hidesWhenStopped = YES;
        [self.view addSubview:self.spinner];
        [self.spinner startAnimating];
    }
    
    NSURL *url = [[NSURL alloc] initWithString:kECDealJSONURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    // Create a completion handler to parse and marshall JSON
    void (^completionHandler) (NSURLResponse* response, NSData* data, NSError* connectionError) =
    ^(NSURLResponse* response, NSData* jsonData, NSError* connectionError) {
        [self.spinner stopAnimating];
        if (!connectionError) {
            NSArray *asyncItems = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                       options:NSJSONReadingMutableLeaves
                                                                         error:nil];
            [self marshallNewData:asyncItems];
            [self.tableView reloadData];
            
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Network Issues"
                                        message:@"We are unable to bring you any deals at this time."
                                       delegate:nil
                              cancelButtonTitle:@"Close"
                              otherButtonTitles:nil] show];
        }
    };
    
    // Request on the main queue (because it's really important) asynchronously (so the UI display gracefully)
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:completionHandler];
}

- (void)marshallNewData:(NSArray *)jsonItems
{
    [_deals removeAllObjects];
    for (NSDictionary *entry in jsonItems) {
        // populate a new deal
        ECDeal *deal = [[ECDeal alloc] init];
        deal.monetaryInvestment = [entry objectForKey:@"attrib"];
        deal.sponsor = [entry objectForKey:@"desc"];
        deal.href = [entry objectForKey:@"href"];
        deal.src = [entry objectForKey:@"src"];
        
        // populate a new user
        NSDictionary *userEntry = [entry objectForKey:@"user"];
        ECUser *user = [[ECUser alloc] init];
        user.name = [userEntry objectForKey:@"name"];
        user.username = [userEntry objectForKey:@"username"];
        
        // populate a user's avatar
        NSDictionary *avatarEntry = [userEntry objectForKey:@"avatar"];
        ECAvatar *avatar = [[ECAvatar alloc] init];
        avatar.src = [avatarEntry objectForKey:@"src"];
        NSString *width = [avatarEntry objectForKey:@"width"];
        NSString *height = [avatarEntry objectForKey:@"height"];
        CGSize size = CGSizeMake([width floatValue], [height floatValue]);
        avatar.size = size;
        
        // set the user's avatar
        user.avatar = avatar;
        
        // set the deal's user
        deal.user = user;
        [_deals addObject:deal];
    }
}

- (IBAction)triggerDealImageActionWithSender:(id)sender
{
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    UIImageView *imageView = (UIImageView *)tapRecognizer.view;
    ECDeal *deal = [self.deals objectAtIndex:imageView.tag];
    NSURL *url = [NSURL URLWithString:deal.href];
    if (![[UIApplication sharedApplication] openURL:url]) {
        // It will be apparent to the user that the browser did not open, so note this for debugging
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // get rid of our images
    for (ECDeal *deal in self.deals) {
        deal.img = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _deals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ECDealCellId";
    ECDealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if ([cell.dealLabel.text isEqualToString:@"Label"]) {
        // This is a new label and it needs a gradient
        cell.gradientView.backgroundColor = [UIColor clearColor];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = cell.gradientView.bounds;
        UIColor *silverColor = [UIColor colorWithRed:198.0f/255.0f green:198.0f/255.0f blue:198.0f/255.0f alpha:0.5];
        gradient.colors = [NSArray arrayWithObjects:(id)[silverColor CGColor], (id)[[UIColor clearColor] CGColor], nil];
        [cell.gradientView.layer insertSublayer:gradient atIndex:0];
    }
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(triggerDealImageActionWithSender:)];
    tapRecognizer.cancelsTouchesInView = YES;
    tapRecognizer.numberOfTapsRequired = 1;
    cell.mainImage.tag = indexPath.row;
    [cell.mainImage addGestureRecognizer:tapRecognizer];
    
    ECDeal *deal = [self.deals objectAtIndex:indexPath.row];
    cell.dealLabel.text = deal.monetaryInvestment;
    cell.sponsorLabel.text = deal.sponsor;
    if (!deal.img) {
        //get a dispatch queue
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSURL *url = [[NSURL alloc] initWithString:deal.src];
            NSData *image = [[NSData alloc] initWithContentsOfURL:url];
            
            //this will set the image when loading is finished
            dispatch_async(dispatch_get_main_queue(), ^{
                deal.img = [UIImage imageWithData:image];
                cell.mainImage.alpha = 0.0f;
                cell.mainImage.image = deal.img;
                [UIView animateWithDuration:0.2f
                                      delay:0.0f
                                    options:UIViewAnimationOptionAllowUserInteraction
                                 animations:^{
                                     cell.mainImage.alpha = 1.0f;
                                 }
                 completion:nil];
            });
        });
    } else {
        cell.mainImage.image = deal.img;
    }
    
    return cell;
}
@end
