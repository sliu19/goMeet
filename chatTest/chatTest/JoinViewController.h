//
//  JoinViewController.h
//  chatTest
//
//  Created by Luyao Huang on 15/2/4.
//  Copyright (c) 2015年 LPP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatClientViewController.h"

@interface JoinViewController : UIViewController<NSStreamDelegate, UITableViewDelegate, UITableViewDataSource,NSStreamDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputMessageField;
- (IBAction)sendMessage:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tView;

@end
NSMutableArray * messages;
