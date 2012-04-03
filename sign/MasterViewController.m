//
//  MasterViewController.m
//  sign
//
//  Created by iwama ryo on 11/12/23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "Editor.h"
#import "GADBannerView.h"

@implementation MasterViewController {
    BOOL _bannerIsVisible;
    UISegmentedControl *_switch;
    NSString *_round;
    GADBannerView *_gAd;
}

@synthesize detailViewController = _detailViewController;
@synthesize bannerIsVisible = _bannerIsVisible;
@synthesize ad = _ad;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.bannerIsVisible = YES;

        self.title = @"9Gえでぃたー";
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
	self.ad.delegate = self;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
	if (self.ad.delegate == nil) {
		self.ad.delegate = self;
	}
    self.ad.requiredContentSizeIdentifiers = [NSSet setWithObjects: ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
    _round = @"DetailViewController";
    NSArray *items = [NSArray arrayWithObjects:@"横書き",@"縦書き",nil];
//    _switch = [[UISegmentedControl alloc] initWithItems:items];
//    _switch.segmentedControlStyle = UISegmentedControlStyleBar;
//    _switch.tintColor = [UIColor grayColor];
//    _switch.selectedSegmentIndex = 0;
//    _switch.frame = CGRectMake(5, 0, 160, 30);
//    [_switch addTarget:self action:@selector(round:) forControlEvents:UIControlEventValueChanged];
//    self.navigationItem.titleView = _switch;

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [userDefaults dictionaryForKey:@"user"];
    _key = [dictionary allKeys];
    _userDic = [dictionary mutableCopy];
    [super viewWillAppear:animated];
    [self.tableView reloadData];

    _gAd = [[GADBannerView alloc]
            initWithFrame:CGRectMake(0.0,
                    self.view.frame.size.height -
                            GAD_SIZE_320x50.height,
                    GAD_SIZE_320x50.width,
                    GAD_SIZE_320x50.height)];

    _gAd.adUnitID = @"a14f0a72713ed6d";
    _gAd.rootViewController = self;
    [_gAd loadRequest:[GADRequest request]];
    self.tableView.tableHeaderView = _gAd;
}

-(void)round:(UISegmentedControl *)segment{
    if (segment.selectedSegmentIndex == 0){
        _switch.selectedSegmentIndex = 0;
        _round = @"DetailViewController";
    }else{
        _switch.selectedSegmentIndex = 1;
        _round = @"Editor";
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.ad.delegate = nil;
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
duration:(NSTimeInterval)duration {
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        self.ad.currentContentSizeIdentifier =
            ADBannerContentSizeIdentifierLandscape;
    else
        self.ad.currentContentSizeIdentifier =
            ADBannerContentSizeIdentifierPortrait;

}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    return YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_userDic count] + 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"NewCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    // Configure the cell.

    cell.textLabel.text = indexPath.row == 0 ? @"新しいファイル" : [[[NSString stringWithFormat:@"%@", [_key objectAtIndex:(NSUInteger) indexPath.row - 1] ] componentsSeparatedByString:@"　"] objectAtIndex:0];
    if (indexPath.row != 0){
        cell.detailTextLabel.text = [[[NSString stringWithFormat:@"%@", [_key objectAtIndex:(NSUInteger) indexPath.row - 1] ] componentsSeparatedByString:@"　"] objectAtIndex:1];
    }
    return cell;

}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        return NO;
    }
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [_userDic removeObjectForKey:[_key objectAtIndex:(NSUInteger) (indexPath.row - 1)]];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:_userDic forKey:@"user"];
        [userDefaults synchronize];
		NSDictionary *dictionary = [userDefaults dictionaryForKey:@"user"];
		_key = [dictionary allKeys];
		_userDic = [dictionary mutableCopy];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


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

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if (self.bannerIsVisible) {
        //バナーを隠します
//        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
//        banner.frame = CGRectOffset(banner.frame, 0, -50);
//        [UIView commitAnimations];
        self.ad.hidden = YES;
        self.bannerIsVisible = NO;
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (!self.bannerIsVisible) {
        //バナーを表示します
//        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
//        banner.frame = CGRectOffset(banner.frame, 0, 50);
//        [UIView commitAnimations];
        self.ad.hidden = NO;
        self.bannerIsVisible = YES;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!self.detailViewController) {
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait){
        Editor *editor;
        if (indexPath.row != 0){
            editor = [[Editor alloc] initWithNibName:@"Editor" bundle:nil title:[_key objectAtIndex:(NSUInteger) indexPath.row - 1] text:[_userDic objectForKey:[_key objectAtIndex:(NSUInteger) (indexPath.row - 1)]]];
        }else{
            editor = [[Editor alloc] initWithNibName:@"Editor" bundle:nil];
        }


        [self.navigationController pushViewController:editor animated:YES];

//    }

    } else{
        if (indexPath.row != 0){
               self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil title:[_key objectAtIndex:(NSUInteger) indexPath.row - 1] text:[_userDic objectForKey:[_key objectAtIndex:(NSUInteger) (indexPath.row - 1)]]];
        }else{
            self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        }
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    }
}

@end
