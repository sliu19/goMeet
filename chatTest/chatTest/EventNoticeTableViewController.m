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

@interface EventNoticeTableViewController ()
@property(strong,nonatomic)NSMutableArray* notificationMessage;
@end

@implementation EventNoticeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    _notificationMessage = [[NSMutableArray alloc]init];
    //pollinvited:{"amount":10,"user_id":6505758650,"start_offset":0}
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = @{@"user_id":[prefs objectForKey:@"userID"],@"amount":@"10",@"start_offset":@"0"};
    NSString *response  = [NSString stringWithFormat:@"pollinvited:%@",[Communication parseIntoJson:dict]];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];
    
       // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding];
                        
                        if (nil != output) {
                            NSLog(@"have friend request available");
                            //output = @"{\"events\":[{\"description\":\"my newsfeed event\",\"title\":\"newfeed event\",\"event_id\":\"47ec6551-fee1-11e4-b58d-a45e60c40087\",\"end_time\":1432120435578,\"begin_time\":1432120425578,\"host_id\":111111111,\"location\":\"newsfeed_event\"},{\"description\":\"my newsfeed event\",\"title\":\"newfeed event\",\"event_id\":\"ecde604c-fee3-11e4-bbb1-a45e60c40087\",\"end_time\":1432121571303,\"begin_time\":1432121561303,\"host_id\":111111111,\"location\":\"newsfeed_event\"}],\"new_friends\":[11111111]}";
                            NSLog(@"OUTPUT is %@",output);
                            NSDictionary*result = [Communication parseFromJson:output];
                            NSArray* resultList = [result objectForKey:@"events"];
                            _notificationMessage = resultList;
                        }

                    }
                }
            }
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            break;
            
        case NSStreamEventEndEncountered:
            break;
            
        default:
            NSLog(@"Unknown event");
    }
    
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
