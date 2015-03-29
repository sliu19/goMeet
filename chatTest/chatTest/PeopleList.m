//
//  PeopleList.m
//  chatTest
//
//  Created by Simin Liu on 3/7/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "PeopleList.h"
#import "Friend.h"
#import "AppDelegate.h"
#import "Personalprofile.h"
@interface PeopleList()

@property (strong, nonatomic) IBOutlet UITableView *peopleListTableView;


@end


@implementation PeopleList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"FriendListPage");

    [self setManagedObjectContent:[(AppDelegate*) [[UIApplication sharedApplication]delegate] managedObjectContext]];
    CGFloat topLayoutGuide = self.topLayoutGuide.length;
    _peopleListTableView.contentInset = UIEdgeInsetsMake(topLayoutGuide, 0, 0, 0);
    
}
-(void)setManagedObjectContent:(NSManagedObjectContext *)managedObjectContent
{
    _managedObjectContent = managedObjectContent;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"userName"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:managedObjectContent sectionNameKeyPath:nil cacheName:nil];
    
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Friend Cell"];
    
    Friend *people = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"This is debug for people list %@",people.userName);
    NSData* userPic = people.userPic;
    cell.textLabel.text = people.userName;
    cell.detailTextLabel.text = @"This is a text detailed text label,future use as distance";
    cell.imageView.image = [[UIImage alloc] initWithData:userPic];
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"Personal Profile"])
    {
        Personalprofile *vc = [segue destinationViewController];
        Friend *people = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
       vc.friend = people;
    }
}



@end