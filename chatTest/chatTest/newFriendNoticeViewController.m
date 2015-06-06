//
//  newFriendNoticeViewController.m
//  chatTest
//
//  Created by Simin Liu on 5/3/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "newFriendNoticeViewController.h"
#import "newFriendNoticeTableViewCell.h"
@interface newFriendNoticeViewController()
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

@end
@implementation newFriendNoticeViewController
-(void)viewDidLoad{
    NSLog(@"at newFriendNotification");
    NSLog(@"current NotificationList is %@",_notificationList);
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    [_mainTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return [_notificationList count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"friendNotificationCell";
    newFriendNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[newFriendNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    NSDictionary* item= _notificationList[indexPath.row];
    NSLog(@"one cell with info%@",_notificationList[indexPath.row]);
    cell.Info = item;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row pressed!!");
}



@end
