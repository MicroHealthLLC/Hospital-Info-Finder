//
//  CustomCell.h
//  tablecell
//
//  Created by Ramesh Patel on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell


@property (retain, nonatomic) IBOutlet UILabel *lblHospitalName;
@property (retain, nonatomic) IBOutlet UIProgressView *progressDefinitelyRecommed;
@property (retain, nonatomic) IBOutlet UIProgressView *progressprobabilyNot;
@property (retain, nonatomic) IBOutlet UILabel *lblMile;
@property (retain, nonatomic) IBOutlet UILabel *lblRecommed;
@property (retain, nonatomic) IBOutlet UILabel *lblprobabily;
@end
