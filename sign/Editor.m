//
//  Editor.m
//  ssnote
//
//  Created by iwama ryo on 11/12/23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Editor.h"
#import "GADBannerView.h"

@interface Editor ()
- (void)configureView;

- (IBAction)saveBack;

- (IBAction)cursorHack:(id)sender;

- (IBAction)addk;

- (NSString *)addSign:(NSString *)text sign:(NSString *)sign signLength:(NSInteger)signLength;


@end

@implementation Editor {
    NSInteger _textId;
    NSString *_text;
    NSString *_textTitle;

    IBOutlet UIView *_nameView;
    IBOutlet UITextField *_nameText;

    IBOutlet UITextView *_textView;

    IBOutlet UIButton *_fBtn;
    IBOutlet UIButton *_bBtn;

    IBOutlet UIButton *_1btn;
    IBOutlet UIButton *_2btn;
    IBOutlet UIButton *_3btn;
    IBOutlet UIButton *_4btn;
    IBOutlet UIButton *_5btn;

    IBOutlet UIView *_key;
    BOOL _bannerIsVisible;
    NSRange _range;

    Editor *_editor;
    UIPinchGestureRecognizer *_gestureRecognizer;
    NSInteger _fontSize;
    GADBannerView *_gAd;
}

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize bannerIsVisible = _bannerIsVisible;
@synthesize textView = _textView;
@synthesize textTitle = _textTitle;
@synthesize text = _text;
@synthesize fBtn = _fBtn;
@synthesize bBtn = _bBtn;


- (void)switchBtn:(BOOL)flg {
    if (flg == YES) {
        _1btn.hidden = YES;
        _2btn.hidden = YES;
        _3btn.hidden = YES;
        _4btn.hidden = YES;
        _5btn.hidden = NO;
    } else {
        _1btn.hidden = NO;
        _2btn.hidden = NO;
        _3btn.hidden = NO;
        _4btn.hidden = NO;
        _5btn.hidden = YES;
    }
}




#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _fontSize = 10;


    [self.navigationController setNavigationBarHidden:YES];
    _textView.inputAccessoryView = _key;
    _textView.text = _text;
    self.bannerIsVisible = YES;

    [_textView becomeFirstResponder];
    _gAd = [[GADBannerView alloc]
            initWithFrame:CGRectMake(0.0,
                    self.view.frame.size.height -
                            GAD_SIZE_320x50.height + 44,
                    GAD_SIZE_320x50.width,
                    GAD_SIZE_320x50.height)];

    _gAd.adUnitID = @"a14f0a72713ed6d";
    _gAd.rootViewController = self;
    [_gAd loadRequest:[GADRequest request]];
    [self.view addSubview:_gAd];


    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(forwardCursor)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [_textView addGestureRecognizer:swipeGestureRecognizer];

    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backCursor)];
    gestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [_textView addGestureRecognizer:gestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillUnload {

    [super viewWillUnload];  //To change the template use AppCode | Preferences | File Templates.
}

BOOL saveViewFlg = NO;

- (IBAction)save {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [userDefaults dictionaryForKey:@"user"];
    NSMutableDictionary *dic = [dictionary mutableCopy];

    NSString *date_converted;
    NSDate *date_source = [NSDate date];

    // NSDateFormatter を用意します。
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    // 変換用の書式を設定します。
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];

    // NSDate を NSString に変換します。
    date_converted = [formatter stringFromDate:date_source];

    if (([_textTitle isEqualToString:@""] || _textTitle == nil) && saveViewFlg == NO) {
        if ([_textView.text isEqualToString:@""] || _textView.text == nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"テキスト空っぽだよ" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        [_nameView removeFromSuperview];
        [self.view addSubview:_nameView];
        saveViewFlg = YES;
        return;
    } else {
        if (([_textTitle isEqualToString:@""] || _textTitle == nil) && ([_nameText.text isEqualToString:@""] || _nameText.text == nil)) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"ファイル名が空っぽだよ" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        [dic setValue:_textView.text forKey:_textTitle ? _textTitle : [NSString stringWithFormat:@"%@　%@", _nameText.text, date_converted]];
        [_nameView removeFromSuperview];
        _textTitle = _textTitle ? _textTitle : [NSString stringWithFormat:@"%@　%@", _nameText.text, date_converted];
        _text = _textView.text;
        saveViewFlg = NO;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"保存しました" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }

    [userDefaults setObject:[NSDictionary dictionaryWithDictionary:dic] forKey:@"user"];
    [userDefaults synchronize];


}

- (IBAction)saveBack {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"保存をキャンセルしました" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    _nameText.text = @"";
    [_nameView removeFromSuperview];
    [_textView becomeFirstResponder];
    saveViewFlg = NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    _textTitle = textField.text;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _textTitle = textField.text;

}

- (IBAction)backCursor {
    NSRange range;
    range.location = _textView.selectedRange.location - 1;
    range.length = _textView.selectedRange.length;
    _textView.selectedRange = range;
}

- (IBAction)forwardCursor {
    NSRange range;
    range.location = _textView.selectedRange.location + 1;
    range.length = _textView.selectedRange.length;
    _textView.selectedRange = range;
}

- (IBAction)cursorHack:(id)sender {
    _textView.text = [self addSign:_textView.text sign:@"" signLength:0];
    _textView.selectedRange = _range;
}


- (IBAction)addk {
    _textView.scrollEnabled = NO;
    _textView.text = [self addSign:_textView.text sign:@"「」" signLength:1];
    _textView.selectedRange = _range;
    _textView.scrollEnabled = YES;
}

- (IBAction)addt {
    _textView.scrollEnabled = NO;
    _textView.text = [self addSign:_textView.text sign:@"（）" signLength:1];
    _textView.selectedRange = _range;
    _textView.scrollEnabled = YES;
}

- (IBAction)addq {
    _textView.scrollEnabled = NO;
    _textView.text = [self addSign:_textView.text sign:@"……" signLength:2];
    _textView.selectedRange = _range;
    _textView.scrollEnabled = YES;
}

- (IBAction)addl {
    _textView.scrollEnabled = NO;
    _textView.text = [self addSign:_textView.text sign:@"――" signLength:2];
    _textView.selectedRange = _range;
    _textView.scrollEnabled = YES;
}

- (NSString *)addSign:(NSString *)text sign:(NSString *)sign signLength:(NSInteger)signLength {
    _range = _textView.selectedRange;
    _range.location = _range.location + signLength;
    NSMutableString *string = [NSMutableString stringWithString:_textView.text];
    [string insertString:sign atIndex:_textView.selectedRange.location];
    return string;
}

- (IBAction)copyAll {
    UIActionSheet *as = [[UIActionSheet alloc] init];
    as.delegate = self;
    as.title = @"一発コピー";
    [as addButtonWithTitle:@"コピー"];
    [as addButtonWithTitle:@"コピーしてBB2Cへ"];
    [as addButtonWithTitle:@"キャンセル"];
    as.cancelButtonIndex = 2;
//    as.destructiveButtonIndex = 0;
    [as showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    switch (buttonIndex) {
        case 0:
            [pasteboard setValue:_textView.text forPasteboardType:@"public.utf8-plain-text"];
            break;
        case 1:
            [pasteboard setValue:_textView.text forPasteboardType:@"public.utf8-plain-text"];
            NSString *url = [NSString stringWithFormat:@"beebee2seeopen:"];
            NSURL *bb2cUrl = [NSURL URLWithString:url];
            if ([[UIApplication sharedApplication] canOpenURL:bb2cUrl]) {
                [[UIApplication sharedApplication] openURL:bb2cUrl];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"9Gえでぃたー" message:@"BB2Cがインストールされてないよ" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            break;
//        case 2:
//            break;
    }

}

- (IBAction)changeFont:(UISegmentedControl *)seg {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (seg.selectedSegmentIndex == 0) {
        [_textView removeGestureRecognizer:_gestureRecognizer];
        _textView.selectedRange = _range;
        _textView.inputAccessoryView = _key;
        _textView.font = [UIFont systemFontOfSize:13];
        CGRect cgRect = _textView.frame;
        cgRect.size.height = 130;
        _textView.frame = cgRect;
        _textView.editable = YES;
        [_textView becomeFirstResponder];
        [self switchBtn:NO];
    } else {
        _gestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(openActionSheet:)];

        [_textView addGestureRecognizer:_gestureRecognizer];
        _range = _textView.selectedRange;
        NSRange range;
        range.length = 0;
        range.location = 0;
        [_textView scrollRangeToVisible:range];
//        _textView.userInteractionEnabled = NO;
        _textView.inputAccessoryView = nil;
        _textView.font = [UIFont systemFontOfSize:10];
        CGRect cgRect = _textView.frame;
        cgRect.size.height = 370;
        _textView.frame = cgRect;
        [_textView resignFirstResponder];
        _textView.editable = NO;
        [self switchBtn:YES];
    }

}

- (void)openActionSheet:(UIPinchGestureRecognizer *)sender {
    UIPinchGestureRecognizer *gestureRecognizer = (UIPinchGestureRecognizer *) sender;
//    NSLog(@"pinch scale=%f, velocity=%f", pinch.scale, pinch.velocity);
    //UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"フォントサイズ" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"13pt",@"11pt",nil];
    //[sheet showInView:self.view];
    // [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        if (![gestureRecognizer.view isKindOfClass:[UITextView class]]) {
            [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
            [gestureRecognizer setScale:1];
        }
    }
    float fs = _fontSize * [gestureRecognizer scale];
    if (fs < 24 && fs > 7) {
        _textView.font = [UIFont systemFontOfSize:fs];
    }
}

- (void)scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer {
    // [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        if (![gestureRecognizer.view isKindOfClass:[UITextView class]]) {
            [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
            [gestureRecognizer setScale:1];
        }
    }
    float fs = _fontSize * [gestureRecognizer scale];
    if (fs < 18 && fs > 9) {
        _textView.font = [UIFont systemFontOfSize:fs];
    }
}

- (void)addGestureRecognizersToPiece:(UIView *)piece {
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
    [pinchGesture setDelegate:self];
    [piece addGestureRecognizer:pinchGesture];
}


- (IBAction)backBtnClick {
    if ([_textView.text isEqualToString:_text]) {
        _textView.text = @"";
        _textTitle = @"";
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"9G" message:@"保存してないけど良いの？" delegate:self cancelButtonTitle:@"だめ" otherButtonTitles:@"いいよ", nil];
        alertView.tag = 999;
        [alertView show];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //To change the template use AppCode | Preferences | File Templates.
    if (alertView.tag == 999 && buttonIndex == 1) {
        _textView.text = @"";
        _textTitle = @"";
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    // Return YES for supported orientations
//    if (UIInterfaceOrientationPortrait == interfaceOrientation){
//        _editor = [[Editor alloc] init];
//        _editor.view.tag = 888;
//        [self.view addSubview:_editor.view];
//    }else{
//        NSArray *array = self.view.subviews;
//        for(UIView *view in array){
//            if (view.tag == 888){
//                [view removeFromSuperview];
//            }
//        }
//    }
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }

    return self;
//To change the template use AppCode | Preferences | File Templates.
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)title text:(NSString *)text {
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
        _text = text;
        _textTitle = title;
    }
    return self;
}

@end
