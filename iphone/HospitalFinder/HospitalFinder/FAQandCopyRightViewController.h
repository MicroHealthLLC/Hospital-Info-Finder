//
//  FAQandCopyRightViewController.h
//  HospitalFinder
//
//  Created by Ramesh Patel on 26/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAQandCopyRightViewController : UITableViewController

{
    NSString *strIdentyfi;
}
@property(nonatomic,retain)NSString *strIdentyfi;
-(float)getHeightByWidth:(NSString*)myString:(UIFont*)mySize:(int)myWidth;
@end
