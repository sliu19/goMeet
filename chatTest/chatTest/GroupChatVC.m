//
//  GroupChatCoreDataTableVC.m
//  chatTest
//
//  Created by Simin Liu on 3/29/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "GroupChatVC.h"
#import "AppDelegate.h"
#import "XMPPFramework.h"
#import "DDLog.h"

// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif


@interface GroupChatVC()

@property (weak, nonatomic) IBOutlet UITableView *groupChatTableView;

@property (weak, nonatomic) IBOutlet UINavigationItem *Title;

@end

@implementation GroupChatVC
- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([[self appDelegate] connect])
    {
        NSLog(@"You are connected with XMPP");
    }
    NSLog(@"GroupChatPage");
    
    [self setManagedObjectContent:[(AppDelegate*) [[UIApplication sharedApplication]delegate] managedObjectContext]];
    _Title.title = _eventElement.eventDescription;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [[self appDelegate] disconnect];
    [[[self appDelegate] xmppvCardTempModule] removeDelegate:self];
    
    [super viewWillDisappear:animated];
}


-(void)setManagedObjectContent:(NSManagedObjectContext *)managedObjectContent
{
    _managedObjectContent = managedObjectContent;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"EventList"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"eventDescription"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    
    self->fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:managedObjectContent sectionNameKeyPath:nil cacheName:nil];
    
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_groupChatTableView dequeueReusableCellWithIdentifier:@"ChatRoomCell"];
    
    EventList *event = [self->fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"This is debug for groupChatCell %@",event.jid);
    cell.textLabel.text = event.eventDescription;
    NSArray* userList = event.groupMember;
    NSString * result = [[userList valueForKey:@"description"] componentsJoinedByString:@" "];
    cell.detailTextLabel.text = result;
    return cell;
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Actions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


@end
