//
//  EventNoticeTableViewController.m
//  chatTest
//
//  Created by Simin Liu on 5/14/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "EventNoticeTableViewController.h"
#import "Communication.h"
#import "EventNoticeTableViewCell.h"
#import "NoticeDetailViewController.h"
#import "AppDelegate.h"
#import "Friend.h"

@interface EventNoticeTableViewController ()
@property(strong,nonatomic)NSMutableArray* notificationMessage;
@end

@implementation EventNoticeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"EventNoticePage");
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    _notificationMessage = [[NSMutableArray alloc]init];
    //pollinvited:{"amount":10,"user_id":6505758650,"start_offset":0}
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = @{@"user_id":[prefs objectForKey:@"userID"],@"amount":@"10",@"start_offset":@"0"};
    NSString *response  = [NSString stringWithFormat:@"pollinvited:%@",[Communication parseIntoJson:dict]];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];
    
}

-(void) viewWillAppear:(BOOL)animated{
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    _notificationMessage = [[NSMutableArray alloc]init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = @{@"user_id":[prefs objectForKey:@"userID"],@"amount":@"10",@"start_offset":@"0"};
    NSString *response  = [NSString stringWithFormat:@"pollinvited:%@",[Communication parseIntoJson:dict]];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_notificationMessage count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventNoticeCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[EventNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"EventNoticeCell"];
    }
    NSDictionary *myevent = _notificationMessage[indexPath.row];
    NSLog(@"EVENT in this row is %@",myevent);
    cell.myEvent = myevent;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


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
                int len;
                
                while ([inputStream hasBytesAvailable]) {
                    len = (int)[inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding];
                        
                        if (nil != output) {
                            NSLog(@"OUTPUT is %@",output);
                            //{"events":[{"description":"","title":"hezij ","event_id":"dfaec4e7-af45-4ba6-94df-4a520149c15f","location":"","begin_time":1434002973,"host_id":6666,"attending_user_ids":[6666],"public":true}]}
                            NSDictionary*result = [Communication parseFromJson:[output dataUsingEncoding:NSUTF8StringEncoding]];
                            NSMutableArray* resultList = [[result objectForKey:@"events"] mutableCopy];
                            if(resultList!=nil){
                                 NSLog(@"have friend invite available,count %lu",(unsigned long)[resultList count]);
                                for (int i=0;i<[resultList count]; i++) {
                                    NSMutableDictionary* temp_info = [[NSMutableDictionary alloc]initWithDictionary:resultList[i]];
                                    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:[(AppDelegate*) [[UIApplication sharedApplication]delegate] managedObjectContext] ];
                                    Friend* friends = [[Friend alloc]initWithEntity:entity insertIntoManagedObjectContext:[(AppDelegate*) [[UIApplication sharedApplication]delegate] managedObjectContext] ];

                                    
                                    friends = [self fetchFriend:[temp_info objectForKey:@"host_id"]];
                                    if(friends!=nil){
                                        [temp_info setValue:friends.userPic forKey:@"userPic"];
                                        [temp_info setValue:friends.userNickName forKey:@"nickName"];
                                    }else{
                                        NSData* userImage = UIImageJPEGRepresentation([UIImage imageNamed:@"blankUser.jpg"],1);
                                        [temp_info setValue:userImage forKey:@"userPic"];
                                        [temp_info setValue:@"" forKey:@"nickName"];
                                    }
                                    [resultList replaceObjectAtIndex:i withObject:temp_info];
                                }
                                _notificationMessage=resultList;
                                [self.tableView reloadData];
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
            // optional - add more buttons:
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

-(Friend*)fetchFriend:(NSString*)user_id
{
    // managedObjectContent = [[[UIApplication sharedApplication]delegate] managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"userID == %@",user_id];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *array = [[NSArray alloc]init];
    array = [[(AppDelegate*) [[UIApplication sharedApplication]delegate] managedObjectContext] executeFetchRequest:request error:&error];
    
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"userID" ascending:YES];
    array = [array sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]];
    if (array != nil&&[array count]!=0) {
        NSUInteger count = [array count]; // May be 0 if the object has been deleted.
        NSLog(@"%lu Friends available",(unsigned long)count);
        return (Friend*) array[0];
    }
    else {
        // Deal with error.
        NSLog(@"No Friends Available");
    }
    return nil;
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier]isEqualToString:@"NoticeDetailSegue"]) {
        NoticeDetailViewController *vc = [segue destinationViewController];
    
        vc.myEvent = [(EventNoticeTableViewCell*)sender myEvent];
    }

}


@end
