//
//  DetailViewController.h
//  sign
//
//  Created by iwama ryo on 11/12/23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface DetailViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate, UIActionSheetDelegate>
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)title text:(NSString *)text;


@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property(nonatomic) BOOL bannerIsVisible;
@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) NSString *textTitle;
@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) UIButton *fBtn;
@property(nonatomic, strong) UIButton *bBtn;


@end
