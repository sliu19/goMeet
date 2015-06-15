//
//  PublicEventViewController.m
//  chatTest
//
//  Created by Simin Liu on 5/6/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "PublicEventTableViewController.h"
#import "PublicEventTableViewCell.h"
#import "PublicEvent.h"

@implementation PublicEventTableViewController
@synthesize publicEventlist;
- (void)viewDidLoad {
    [super viewDidLoad];
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    publicEventlist = [[NSMutableArray alloc]init];
    self.tableView.allowsSelection = NO;
    NSLog(@"PublicEventTableViewController");
    [self refreshNews];
}

-(void)viewWillAppear:(BOOL)animated{
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
}
- (IBAction)refreshButton:(id)sender {
    [self refreshNews];
}

-(void)refreshNews{
    //pollnewsfeed:{"amount":10,"user_id":22222222,"start_offset":0}
    publicEventlist = [[NSMutableArray alloc]init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = @{@"amount":@"10",@"user_id":[prefs objectForKey:@"userID"],@"start_offset":@"0"};
    NSString *response  = [NSString stringWithFormat:@"pollnewsfeed:%@",[Communication parseIntoJson:dict]];    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];
}

#pragma tableView editor help
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return [publicEventlist count];
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"PublicEventCell";
    PublicEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[PublicEventTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    PublicEvent *myevent = publicEventlist[indexPath.row];
    cell.eventItem = myevent;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableViewWWWW:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row pressed!!");
}






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
                        
                        NSData *output = [[NSData alloc] initWithBytes:buffer length:len];
                        if (nil != output) {
                            NSDictionary*result = [Communication parseFromJson:output ];
                            NSLog(@"OUTPUT is %@",result);
                            for(NSDictionary* event in [result objectForKey:@"events"]){
                                NSLog(@"this event is %@",event);
                                PublicEvent* testEvent = [[PublicEvent alloc]init:event];
                                [publicEventlist addObject:testEvent];
                            }
                            [self.tableView reloadData];
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
            //[alert addButtonWithTitle:@"Yes"];
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
