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
#import "EventListTableViewCell.h"
#define ROW_HEIGHT 172.0

@interface EventTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *EventTableView;


@end

@implementation EventTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Disable grouptalk for now
    //TO DO:
    self.tableView.allowsSelection= NO;
    NSLog(@"EventListPage");
    [self setManagedObjectContent:[(AppDelegate*) [[UIApplication sharedApplication]delegate] managedObjectContext]];
    CGFloat topLayoutGuide = self.topLayoutGuide.length;
    _EventTableView.contentInset = UIEdgeInsetsMake(topLayoutGuide, 0, 0, 0);
    self.tableView.rowHeight = ROW_HEIGHT;
    self.tableView.estimatedRowHeight = ROW_HEIGHT;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backGround"]];
    
}
-(void)setManagedObjectContent:(NSManagedObjectContext *)managedObjectContent
{
    _managedObjectContent = managedObjectContent;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"EventList"];
    request.predicate = nil;
    NSDate *mydate = [NSDate date];
    NSTimeInterval secondsInHours =  -60 * 60 * 24;
    NSDate *dateHoursAhead = [mydate dateByAddingTimeInterval:secondsInHours];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"time >= %@",dateHoursAhead];
    [request setPredicate:predicate];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time"
                                                              ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:managedObjectContent sectionNameKeyPath:nil cacheName:nil];
    
}

#pragma TableCell setup
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Draw on event");
    EventList *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    EventListTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    cell.myEvent = event;
    cell.backgroundColor = [self.view backgroundColor];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform the real delete action here. Note: you may need to check editing style
    //   if you do not perform delete only.
    NSLog(@"Deleted row.");
    [_managedObjectContent deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    [self.tableView reloadData];
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
