//
//  GroupChatCoreDataTableVC.h
//  chatTest
//
//  Created by Simin Liu on 3/29/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EventList.h"
#import "XMPPRoom.h"
#import "XMPPMUC.h"
#import "XMPPFramework.h"

@interface GroupChatVC :UIViewController<NSFetchedResultsControllerDelegate,XMPPMUCDelegate,XMPPRoomDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSFetchedResultsController *fetchedResultsController;
}



@property(nonatomic,strong) NSManagedObjectContext *managedObjectContent;
@property (nonatomic,strong) EventList* eventElement;


@property (nonatomic, strong, readonly) XMPPRoomCoreDataStorage * xmppRoomStorage;
@property (nonatomic, strong, readonly) XMPPRoom * xmppRoom;
@property (nonatomic, strong, readonly) XMPPStream* xmppStream;
//@property (nonatomic, strong, readonly)

@end
