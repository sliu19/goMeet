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

@interface CreateNewEventViewController()

@property (weak, nonatomic) IBOutlet UITextField *EventDescription;
@property (nonatomic, assign) id currentResponder;
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
    [_EventDescription setDelegate:self];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    singleTap.numberOfTapsRequired = 1;
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
    
    
    //Create Room
    
    xmppStream = [self appDelegate].xmppStream;
    [self initxmpproom:uuidString];
    
    //Return to main page
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainTabBarViewController *viewController = (MainTabBarViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GoMeet"];
    [viewController setSelectedIndex:2];
    [self presentViewController:viewController animated:YES completion:nil];
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




@end
