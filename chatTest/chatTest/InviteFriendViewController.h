//
//  InviteFriendViewController.h
//  chatTest
//
//  Created by Simin Liu on 5/15/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonButton.h"
#import "CreateNewEventViewController.h"

@interface InviteFriendViewController : UIViewController<UITextFieldDelegate,UISearchBarDelegate>
@property(nonatomic,strong)CreateNewEventViewController* orginalController;
@end
