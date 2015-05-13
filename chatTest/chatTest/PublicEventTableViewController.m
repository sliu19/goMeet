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
    [Communication initNetworkCommunication];
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    publicEventlist = [[NSMutableArray alloc]init];
    
    PublicEvent* testEvent = [[PublicEvent alloc]init:@{@"time":@"testTime",@"title":@"testTitle", @"location":@"testLocation"}];
    [publicEventlist addObject:testEvent];
    NSLog(@"PublicEventTableViewController");
}



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
    EventList *myevent = publicEventlist[indexPath.row];
    cell.eventItem = myevent;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output) {
                            switch (output.intValue) {
                                case 1:
                                    NSLog(@"trigger segue");
                                    [self performSegueWithIdentifier:@"login" sender:nil];
                                    
                                    break;
                                    
                                default:
                                    NSLog(@"output int val %@", output.intValue);
                                    break;
                            }
                            NSLog(@"server said: %@", output);
                            
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



@end
