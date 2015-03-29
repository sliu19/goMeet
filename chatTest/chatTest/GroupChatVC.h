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
@interface GroupChatVC :UIViewController<NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *fetchedResultsController;
}



@property(nonatomic,strong) NSManagedObjectContext *managedObjectContent;
@property (nonatomic,strong) EventList* eventElement;

@end
