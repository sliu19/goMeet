//
//  EventTableViewController.m
//  chatTest
//
//  Created by Simin Liu on 3/28/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "EventTableViewController.h"
#import "EventList.h"
#import "AppDelegate.h"
#import "GroupChatVC.h"

@interface EventTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *EventTableView;


@end

@implementation EventTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"EventListPage");
    
    [self setManagedObjectContent:[(AppDelegate*) [[UIApplication sharedApplication]delegate] managedObjectContext]];
    CGFloat topLayoutGuide = self.topLayoutGuide.length;
    _EventTableView.contentInset = UIEdgeInsetsMake(topLayoutGuide, 0, 0, 0);
    
}
-(void)setManagedObjectContent:(NSManagedObjectContext *)managedObjectContent
{
    _managedObjectContent = managedObjectContent;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"EventList"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"eventDescription"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:managedObjectContent sectionNameKeyPath:nil cacheName:nil];
    
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    
    EventList *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"This is debug for event list %@",event.jid);
    cell.textLabel.text = event.eventDescription;
    NSArray* userList = event.groupMember;
    NSLog(@"userList convert to String is %@",userList);
    NSString * result = [[userList valueForKey:@"description"] componentsJoinedByString:@" "];
    cell.detailTextLabel.text = result;
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"EventChat"])
    {
        GroupChatVC *vc = [segue destinationViewController];
        EventList *event = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        vc.eventElement = event;
    }
}





@end
