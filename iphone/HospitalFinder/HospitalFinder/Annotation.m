//
//  Annotation.m
//  Annotation
//
//  Created by Lenzo on 10.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Annotation.h"


@implementation Annotation
@synthesize coordinate, title, subtitle;

//- (NSString *)title {
//    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"latitude : %f,\nlongitude : %f", coordinate.latitude, coordinate.longitude] forKey:@"title"];
//    return [NSString stringWithFormat:@"%f, %f", coordinate.latitude, coordinate.longitude];
//}
-(void)dealloc {
    
    [title release];
    [super dealloc];
    
}

@end
