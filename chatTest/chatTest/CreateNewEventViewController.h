//
//  CreateNewEventViewController.h
//  chatTest
//
//  Created by Simin Liu on 3/28/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "XMPPRoom.h"
#import "XMPPMUC.h"
#import "XMPPFramework.h"

@interface CreateNewEventViewController : UIViewController<UITextFieldDelegate,XMPPMUCDelegate,XMPPRoomDelegate,NSStreamDelegate,UIScrollViewDelegate>


@property (nonatomic, strong, readonly) XMPPRoomCoreDataStorage * xmppRoomStorage;
@property (nonatomic, strong, readonly) XMPPRoom * xmppRoom;
@property (nonatomic, strong, readonly) XMPPStream* xmppStream;
@property(nonatomic,strong)NSMutableArray* inviteList;

- (void)setFoo:(NSMutableArray *)inviteList;

@end
