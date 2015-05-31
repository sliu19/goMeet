//
//  InviteFriendViewController.h
//  chatTest
//
//  Created by Simin Liu on 5/15/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendCell.h"
#import "CreateNewEventViewController.h"
@class CreatNewEventController;

@interface InviteFriendViewController : UIViewController<UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)CreateNewEventViewController* orginalController;

@end
