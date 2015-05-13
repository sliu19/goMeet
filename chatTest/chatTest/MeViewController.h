//
//  MeViewController.h
//  chatTest
//
//  Created by Simin Liu on 3/22/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OwnerNewsFeed.h"
#import "PublicEvent.h"

@interface MeViewController : UIViewController
@property(nonatomic,strong) NSManagedObjectContext *managedObjectContent;

@end
