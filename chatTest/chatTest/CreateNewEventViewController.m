//
//  CreateNewEventViewController.m
//  chatTest
//
//  Created by Simin Liu on 3/28/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "CreateNewEventViewController.h"
#import "EventList.h"


@interface CreateNewEventViewController()

@property (weak, nonatomic) IBOutlet UITextField *EventDescription;
@property (nonatomic, assign) id currentResponder;
@end


@implementation CreateNewEventViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_EventDescription setDelegate:self];
    
}

- (IBAction)AddEvent:(id)sender {
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString* uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);

    
    EventList* event = nil;
    event = [NSEntityDescription insertNewObjectForEntityForName:@"EventList" inManagedObjectContext:[(AppDelegate*) [[UIApplication sharedApplication]delegate] managedObjectContext]];
    [event setValue: _EventDescription.text forKey :@"eventDescription"];
    [event setValue: uuidString forKey :@"jid"];
    [event setValue: @"UIUC" forKey :@"location"];
    NSDate* now = [NSDate date];
    [event setValue:now forKey:@"time"];
    NSArray* userList =@[@"user1",@"user2",@"user3"];
    [event setValue: userList forKey:@"groupMember"];
    [event setGroupMember:userList];
    NSLog(@"GroupMember when set is %@",[[NSString alloc] initWithData:event.groupMember_data encoding:NSUTF8StringEncoding]);
    _EventDescription.text = @"";


}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}



@end
