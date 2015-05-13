//
//  PublicEventViewController.h
//  chatTest
//
//  Created by Simin Liu on 5/6/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"
#import "EventList.h"
@interface PublicEventTableViewController : UITableViewController<NSStreamDelegate,UITableViewDataSource,UITableViewDelegate>


@property(strong,nonatomic)NSMutableArray* publicEventlist;
@end
