//
//  addNewsFeedViewController.h
//  chatTest
//
//  Created by Simin Liu on 3/19/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsFeed.h"
#import "NewsFeedViewController.h"

@interface addNewsFeedViewController : UIViewController<UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *outImageView;
@end