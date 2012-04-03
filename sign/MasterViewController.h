//
//  MasterViewController.h
//  sign
//
//  Created by iwama ryo on 11/12/23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController<ADBannerViewDelegate>{
    NSMutableDictionary *_userDic;
    NSArray *_key;
    IBOutlet ADBannerView *_ad;
}

@property (strong, nonatomic) DetailViewController *detailViewController;
@property(nonatomic) BOOL bannerIsVisible;
@property(nonatomic, strong) ADBannerView *ad;


@end
