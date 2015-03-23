//
//  LocationSettingViewController.h
//  HospitalFinder
//
//  Created by Ramesh Patel on 20/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationSettingViewController : UITableViewController<UIAlertViewDelegate,UITextFieldDelegate>
{
    UILabel *lblmile;
    UITextField *txtMile;
    UILabel *lblState;
}
@property (retain, nonatomic) IBOutlet UITableView *tblview;

@end
