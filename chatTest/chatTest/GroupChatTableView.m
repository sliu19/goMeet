//
//  GroupChatTableView.m
//  chatTest
//
//  Created by Simin Liu on 5/2/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "GroupChatTableView.h"
#import "GroupChatTableViewCell.h"
#import "Message.h"

@implementation GroupChatTableView
@synthesize messageHistory;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    Message* messageItem = [self.messageHistory objectAtIndex:indexPath.row];
    
    GroupChatTableViewCell *cell = [self dequeueReusableCellWithIdentifier:@"EventCell"];
    //NSLog(@"Cell frame is %@",cell.frame.size.height);
    //cell.contentView.backgroundColor = [UIColor clearColor];
    cell.myMessage = messageItem;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row pressed!!");
}

@end
