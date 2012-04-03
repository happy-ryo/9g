//
//  Created by happy_ryo on 11/12/24.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface GTextView : UITextView
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic, retain) UIColor *lineColor;
@end