//
//  NewsFeedViewController.h
//  chatTest
//
//  Created by Simin Liu on 2/18/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"
#import "NewsFeed.h"

@interface NewsFeedViewController : UIViewController<NSStreamDelegate>
@property (strong,nonatomic) NSMutableArray* newsList;
@end
