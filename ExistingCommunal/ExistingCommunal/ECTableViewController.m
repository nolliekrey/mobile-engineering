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

@interface ECTableViewController ()
// Fetches JSON data from the server and parses it
- (void)fetchData;

// Collection of Existing Communal deals downloaded from kECDealJSONURL
@property(nonatomic, strong)NSMutableArray *deals;

@end

// The URL string that will be used to fetch data from the server
NSString * const kECDealJSONURL = @"http://sheltered-bastion-2512.herokuapp.com/feed.json";

@implementation ECTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _deals = [[NSMutableArray alloc] init];
    [self fetchData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)fetchData
{
    NSURL *url = [[NSURL alloc] initWithString:kECDealJSONURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    // Create a completion handler to parse and marshall JSON
    void (^completionHandler) (NSURLResponse* response, NSData* data, NSError* connectionError) =
    ^(NSURLResponse* response, NSData* jsonData, NSError* connectionError) {
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    ECDeal *deal = [self.deals objectAtIndex:indexPath.row];
    cell.label.text = deal.user.avatar.src;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
