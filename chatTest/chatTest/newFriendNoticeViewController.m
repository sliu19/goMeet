//
//  newFriendNoticeViewController.m
//  chatTest
//
//  Created by Simin Liu on 5/3/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "newFriendNoticeViewController.h"
#import "newFriendNoticeTableViewCell.h"
#import "Communication.h"
#import <Parse/Parse.h>
@interface newFriendNoticeViewController()
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

@end
@implementation newFriendNoticeViewController
-(void)viewDidLoad{
    NSLog(@"at newFriendNotification");
    NSLog(@"current NotificationList is %@",_notificationList);
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    _mainTableView.allowsSelection = NO;
    
}
-(void) viewDidAppear:(BOOL)animated{
    [self setUp];
    [_mainTableView reloadData];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(void)setUp{
    [outputStream setDelegate:self];
    [inputStream setDelegate:self];
    _notificationImageList = [[NSMutableArray alloc]init];
    _userInfoList=[[NSMutableArray alloc]init];
    NSMutableArray* userIDList = [[NSMutableArray alloc]init];
    for(NSDictionary* oneUser in _notificationList){
        [userIDList addObject:[oneUser objectForKey:@"phone"]];
    }
    NSDictionary* dict = @{@"seekList":userIDList};
    NSString *response  = [NSString stringWithFormat:@"multiseekuser:%@",[Communication parseIntoJson:dict]];
    NSLog(@"Asked multifriend %@",response);
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];
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
    if([_notificationImageList count]>indexPath.row){
        NSLog(@"I HAVE userInfo is %@",_userInfoList[indexPath.row]);
        cell.userPic = _notificationImageList[indexPath.row];
        cell.userInfo = _userInfoList[indexPath.row];
        [cell changePicure];
    }
    else{
        NSLog(@"no userPic");
        cell.userPic = UIImageJPEGRepresentation([UIImage imageNamed:@"blankUser.jpg"],1);
    }
    return cell;
}


#pragma mark - Table view delegate
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    typedef enum {
        NSStreamEventNone = 0,
        NSStreamEventOpenCompleted = 1 << 0,
        NSStreamEventHasBytesAvailable = 1 << 1,
        NSStreamEventHasSpaceAvailable = 1 << 2,
        NSStreamEventErrorOccurred = 1 << 3,
        NSStreamEventEndEncountered = 1 << 4
    }NSStringEvent;
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
            
        case NSStreamEventHasBytesAvailable:
            
            if (theStream == inputStream) {
                
                uint8_t buffer[1024];
                NSInteger len;
                
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSData *output = [[NSData alloc] initWithBytes:buffer length:len];
                        if (nil != output) {
                            NSDictionary*result = [Communication parseFromJson:output];
                            NSLog(@"OUTPUT is %@",result);
                            if([result objectForKey:@"multiSeekDict"]!=nil){
                                NSDictionary* userInfoList =[result objectForKey:@"multiSeekDict"];
                                NSLog(@"multisuerlist is %@",userInfoList);
                                for (NSDictionary* account in [userInfoList allValues]){
                                    PFQuery *query = [PFQuery queryWithClassName:@"People"];
                                    [query getObjectInBackgroundWithId:[account objectForKey:@"parseID"] block:^(PFObject *user, NSError *error) {
                                        // Do something with the returned PFObject in the gameScore variable.
                                        NSLog(@"FriendInfo is %@",account);
                                        NSData* imgData =[user[@"smallPicFile"] getData];
                                        [_notificationImageList addObject:imgData];
                                        [_userInfoList addObject:account];
                                        [_mainTableView reloadData];
                                    }];
    
                                }
                            }
                        }
                    }
                }
            }
            break;
            
        case NSStreamEventErrorOccurred:
        {
            NSLog(@"Can not connect to the host!");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"链接不上服务器" message:@"稍微晚些时候试试吧？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
            [Communication initNetworkCommunication];
            break;
        }
        case NSStreamEventEndEncountered:
            break;
            
        default:
            NSLog(@"Unknown event");
    }
    
}


@end
