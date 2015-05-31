//
//  MeViewController.h
//  chatTest
//
//  Created by Simin Liu on 3/22/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicEvent.h"

@interface MeViewController : UIViewController<NSStreamDelegate>
@property(nonatomic,strong) NSManagedObjectContext *managedObjectContent;

@end
