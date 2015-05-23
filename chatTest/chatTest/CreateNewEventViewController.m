//
//  CreateNewEventViewController.m
//  chatTest
//
//  Created by Simin Liu on 3/28/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "CreateNewEventViewController.h"
#import "EventList.h"
#import "MainTabBarViewController.h"
#import "Communication.h"

@interface CreateNewEventViewController()
@property (weak, nonatomic) IBOutlet UIScrollView *mainView;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *EventTitle;
@property (weak, nonatomic) IBOutlet UITextField *EventLocation;
@property (weak, nonatomic) IBOutlet UITextField *EventTime;
@property (weak, nonatomic) IBOutlet UITextField *EventDescription;

@property (weak, nonatomic) IBOutlet UIButton *public;

@property (nonatomic, assign) id currentResponder;
@property (nonatomic,strong) NSString* PUBLIC;
@property (nonatomic,strong)NSString* uuid;
@end


@implementation CreateNewEventViewController

@synthesize xmppStream;
@synthesize xmppRoom;
@synthesize xmppRoomStorage;

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_EventTitle setDelegate:self];
    [_EventTime setDelegate:self];
    [_EventLocation setDelegate:self];
    [_EventDescription setDelegate:self];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    singleTap.numberOfTapsRequired = 1;
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    _inviteList = [[NSMutableArray alloc]init];
    _PUBLIC = @"false";
}

- (IBAction)AddEvent:(id)sender {
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString* uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    _uuid = uuidString;
    
    EventList* event = nil;
    event = [NSEntityDescription insertNewObjectForEntityForName:@"EventList" inManagedObjectContext:[(AppDelegate*) [[UIApplication sharedApplication]delegate] managedObjectContext]];
    [event setValue: _EventDescription.text forKey :@"eventDescription"];
    [event setValue: uuidString forKey :@"jid"];
    [event setValue: _EventLocation.text forKey :@"location"];
    [event setValue: _EventTitle.text forKey :@"title"];
    NSDate* now = [NSDate date];
    [event setValue:now forKey:@"time"];
    _inviteList =@[@"11111111",@"222222222",@"333333"];
    [event setValue: _inviteList forKey:@"groupMember"];
    [event setGroupMember:_inviteList];
    NSLog(@"GroupMember when set is %@",[[NSString alloc] initWithData:event.groupMember_data encoding:NSUTF8StringEncoding]);
    int unixTime = [_datePicker.date timeIntervalSince1970];
    
    
    //Create Room
    
    xmppStream = [self appDelegate].xmppStream;
    [self initxmpproom:uuidString];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //Also sent to server
    //newevent:{"description":"my description","title":"my event title4","event_id":"acf6830f-f945-11e4-a2bf-b8e85632007e","invite_list":[68958333],"location":"test event location4","time":1431503837791,"host_id":12341333,"public":false}
    //newPublicEvent:{"description":"my newsfeed event","title":"newfeed event","event_id":"47ec6551-fee1-11e4-b58d-a45e60c40087","start_time":1432120425578,"location":"newsfeed_event","host_id":111111111,"end_time":1432120435578}
    NSDictionary*dict = @{@"title":_EventTitle.text,@"event_id":uuidString,@"invite_list":_inviteList,@"location":_EventLocation.text,@"start_time":[NSString stringWithFormat:@"%d", unixTime ],@"host_id":[prefs objectForKey:@"userID"],@"end_time":@"1432155744",@"description":_EventDescription.text};
    NSString *response  = [NSString stringWithFormat:@"newPublicEvent:%@",[Communication parseIntoJson:dict]];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];
    
    _EventDescription.text = @"";
    _EventTitle.text = @"";
    _EventLocation.text = @"";
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
    // self.becomeFirstResponder();
}
- (IBAction)cancelButton:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainTabBarViewController *viewController = (MainTabBarViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GoMeet"];
    [viewController setSelectedIndex:2];
    [self presentViewController:viewController animated:YES completion:nil];

}



-(void)initxmpproom:(NSString*)uuid{
    xmppRoomStorage  = [XMPPRoomCoreDataStorage sharedInstance];
    NSString* roomJIDString = [[NSString alloc]initWithFormat:@"%@@conference.ip-172-31-20-117",uuid];
    XMPPJID *roomJID = [XMPPJID jidWithString:roomJIDString];
    xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:xmppRoomStorage jid:roomJID  dispatchQueue:dispatch_get_main_queue()];
    XMPPStream *stream = [self xmppStream];
    
    [xmppRoom activate:stream];
    //[xmppRoom activate:[[XMPPManager sharedManager] xmppStream]];
    //[xmppRoom activate:xmppStream];
    [self performSelector:@selector(joinroom) withObject:nil afterDelay:2];
    [self joinroom];
    //[xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

-(void)joinroom{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //Join with userID
    //[xmppRoom joinRoomUsingNickname:[prefs stringForKey:@"userID"] history:nil];
    [xmppRoom joinRoomUsingNickname:@"user3" history:nil];
    [xmppRoom fetchConfigurationForm];
    [xmppRoom configureRoomUsingOptions:nil];
}


#pragma mark 配置房间为永久房间
-(void)sendDefaultRoomConfig
{
    
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
    
    NSXMLElement *field = [NSXMLElement elementWithName:@"field"];
    NSXMLElement *value = [NSXMLElement elementWithName:@"value"];
    
    NSXMLElement *fieldowners = [NSXMLElement elementWithName:@"field"];
    NSXMLElement *valueowners = [NSXMLElement elementWithName:@"value"];
    
    
    [field addAttributeWithName:@"var" stringValue:@"muc#roomconfig_persistentroom"];  // 永久属性
    [fieldowners addAttributeWithName:@"var" stringValue:@"muc#roomconfig_roomowners"];  // 谁创建的房间
    
    
    [field addAttributeWithName:@"type" stringValue:@"boolean"];
    [fieldowners addAttributeWithName:@"type" stringValue:@"jid-multi"];
    
    [value setStringValue:@"1"];
    [valueowners setStringValue:[xmppStream myJID].bare]; //创建者的Jid
    
    [x addChild:field];
    [x addChild:fieldowners];
    [field addChild:value];
    [fieldowners addChild:valueowners];
    
    [xmppRoom configureRoomUsingOptions:x];
    
}

// 房间创建成功后在配置永久属性
#pragma mark - 创建讨论组成功回调
- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
    [self sendDefaultRoomConfig];
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
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding];
                        
                        if (nil != output) {
                            NSLog(@"server said: \"%@\", our uuid \"%@\"", [output uppercaseString],_uuid);
                            if ([[output uppercaseString] isEqualToString:_uuid]) {
                                //Return to main page
                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                MainTabBarViewController *viewController = (MainTabBarViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GoMeet"];
                                [viewController setSelectedIndex:2];
                                [self presentViewController:viewController animated:YES completion:nil];

                            }
                            
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
