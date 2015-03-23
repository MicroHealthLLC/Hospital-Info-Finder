//
//  HospitalFinderSettingViewController.h
//  HospitalFinder
//
//  Created by Ramesh Patel on 26/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface HospitalFinderSettingViewController : UITableViewController<MFMailComposeViewControllerDelegate>
{
    MFMailComposeViewController *mailPicker;
}

@end
