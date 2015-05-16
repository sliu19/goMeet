//
//  GroupChatCoreDataTableVC.m
//  chatTest
//
//  Created by Simin Liu on 3/29/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "GroupChatVC.h"
#import "AppDelegate.h"
#import "XMPPFramework.h"
#import "DDLog.h"
#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPLogging.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"

#import "DDLog.h"
#import "DDTTYLogger.h"

#import <CFNetwork/CFNetwork.h>

#import "MainTabBarViewController.h"

#import "GroupChatTableViewCell.h"
#import "Message.h"


// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif


#define CHATROOM @"test chatroom"

@interface GroupChatVC()

@property (weak, nonatomic) IBOutlet UITableView *groupChatTableView;

@property (weak, nonatomic) IBOutlet UINavigationItem *Title;

@property (nonatomic,strong) XMPPRoom* chatRoom;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (nonatomic, assign) id currentResponder;
@property (nonatomic,strong)NSMutableArray* messageHistory;
@end

@implementation GroupChatVC

@synthesize xmppRoomStorage;
@synthesize xmppRoom;
@synthesize xmppStream;
@synthesize eventElement;
@synthesize messageHistory;

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[self appDelegate] connect])
    {
        NSLog(@"You are connected with XMPP");
    }
    NSLog(@"GroupChatPage");
    
    [self setManagedObjectContent:[(AppDelegate*) [[UIApplication sharedApplication]delegate] managedObjectContext]];
    _Title.title = eventElement.eventDescription;
    xmppStream = [self appDelegate].xmppStream;
    [self initxmpproom];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    singleTap.numberOfTapsRequired = 1;
    [_groupChatTableView setUserInteractionEnabled:YES];
    [_groupChatTableView addGestureRecognizer:singleTap];
    [self inputTextField].delegate=self;
    NSUInteger count = [eventElement.message count]; // May be 0 if the object has been deleted.
    NSLog(@"%lu Messages available",(unsigned long)count);
    //NSMutableArray* newsFeedArray = [[NSMutableArray alloc]init];
    // for( Friend* friends in sortedList){
    
    messageHistory = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<count; i++) {
        [messageHistory addObject:eventElement.message[i]];
    }

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //Send through NSStrem
    NSString* userId = [prefs stringForKey:@"userID"];

    Message* sampleMessage = [[Message alloc]init:@"Test message" name:@"UserAmy"];
    Message* sampleMyMessage = [[Message alloc]init:@"Test message is soooo long but not sure how to do autosize" name:userId];
    [messageHistory addObject:sampleMessage];
    [messageHistory addObject:sampleMessage];
    [messageHistory addObject:sampleMyMessage];
    [messageHistory addObject:sampleMessage];
    [messageHistory addObject:sampleMessage];
    [messageHistory addObject:sampleMyMessage];
    [messageHistory addObject:sampleMessage];
    [messageHistory addObject:sampleMyMessage];
    
    _groupChatTableView.delegate = self;
    _groupChatTableView.dataSource = self;
    [_groupChatTableView reloadData];
    _groupChatTableView.rowHeight = UITableViewAutomaticDimension;

}

-(void)initxmpproom{
    //TO DO: Get response from server
    //[self getrooms];
    //NSString* roomJIDString = [NSString stringWithFormat:@"%@@54.69.204.42",eventElement.jid];
    //NSLog(@"roomJIDString is %@",roomJIDString);
    xmppRoomStorage  = [XMPPRoomCoreDataStorage sharedInstance];
    NSString* roomJIDString = [[NSString alloc]initWithFormat:@"%@@conference.ip-172-31-20-117",eventElement.jid];
    XMPPJID *roomJID = [XMPPJID jidWithString:roomJIDString];
    xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:xmppRoomStorage jid:roomJID  dispatchQueue:dispatch_get_main_queue()];
    XMPPStream *stream = [self xmppStream];
    
    [xmppRoom activate:stream];
    //[xmppRoom activate:[[XMPPManager sharedManager] xmppStream]];
    //[xmppRoom activate:xmppStream];
    //[self performSelector:@selector(joinroom) withObject:nil afterDelay:2];
    //[self joinroom];
    [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

-(void)joinroom{
    
    [xmppRoom joinRoomUsingNickname:@"user3" history:nil];
    
 
    
    [xmppRoom fetchConfigurationForm];
    [xmppRoom configureRoomUsingOptions:nil];
}



-(void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID{
    NSLog(@"群发言了。。。。");
    
    NSString *type = [[message attributeForName:@"type"] stringValue];
    //NSLog(
    if ([type isEqualToString:@"groupchat"]) {
        NSString *msg = [[message elementForName:@"body"] stringValue];
        NSLog(@"MESSAGEBOdy is %@",msg);
        //NSString *timexx = [[timex attributeForName:@"stamp"] stringValue];
        NSString *from = [[message attributeForName:@"from"] stringValue];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:msg forKey:@"body"];
        [dict setObject:from forKey:@"from"];
        
        //消息委托
        [self newMessageReceived:dict];
    }
    
}

- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID
{
    NSLog(@"新人加入群聊");
}


- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID
{
    NSLog(@"有人退出群聊");
}

- (IBAction)sendPress:(UIButton *)sender {
    NSLog(@"Press Send");
    //本地输入框中的信息
    //TO DO:Add textfield
    NSString *message = _inputTextField.text;
    
    _inputTextField.text = @"";
    [_inputTextField resignFirstResponder];
    
    if (message.length > 0){
        [xmppRoom sendMessageWithBody:@"TEST message is "];
        NSLog(@"Send message: %@",message);
    }
    _inputTextField.text = @"Answer here...";
    
}
- (IBAction)InviteNewFriend:(UIBarButtonItem *)sender {
    
    XMPPJID *user2JID = [XMPPJID jidWithString:@"yi@ip-172-31-20-117"];
    [xmppRoom inviteUser: user2JID withMessage:@"This is a invitation reason"];
    
}

-(void)newMessageReceived:(NSDictionary *)messageContent{
    //[arr1 addObject:messageContent];
    //[self.tableview1 reloadData];
    
    //if (self.tableview1.contentSize.height > self.tableview1.frame.size.height) {
      //  [self.tableview1 setContentOffset:CGPointMake(0, self.tableview1.contentSize.height - self.tableview1.frame.size.height)];
   // }
    
    NSLog(@"receive message %@, from %@", messageContent[@"body"], messageContent[@"from"]);
    
    Message* newMess = [[Message alloc]init:messageContent[@"body"] name:messageContent[@"from"]];
    [messageHistory addObject:newMess];
    [_groupChatTableView reloadData];
}


- (void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *)roomJID didReceiveInvitation:(XMPPMessage *)message{};
- (void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *)roomJID didReceiveInvitationDecline:(XMPPMessage *)message{};



- (void)viewWillDisappear:(BOOL)animated
{
    [[self appDelegate] disconnect];
    [[[self appDelegate] xmppvCardTempModule] removeDelegate:self];
    [super viewWillDisappear:animated];
    eventElement.message_data = [NSKeyedArchiver archivedDataWithRootObject:messageHistory];
}




-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    NSLog(@"textFieldShouldEdit");
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"textFieldDidBeginEdit");
    _inputTextField.text = @"";
    self.currentResponder = textField;
}

- (void)resignOnTap:(id)iSender {
    NSLog(@"Single tab detacted, current responder is %@",self.currentResponder);
    [self.currentResponder resignFirstResponder];
    // self.becomeFirstResponder();
}
- (IBAction)clickBack:(UIBarButtonItem *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainTabBarViewController *viewController = (MainTabBarViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GoMeet"];
    [viewController setSelectedIndex:2];
    [self presentViewController:viewController animated:YES completion:nil];
}


- (void)handleIncomingMessage:(XMPPMessage *)message room:(XMPPRoom *)room{
    
}
- (void)handleOutgoingMessage:(XMPPMessage *)message room:(XMPPRoom *)room{
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return [messageHistory count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MessageCell";
    GroupChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[GroupChatTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    Message *message = messageHistory[indexPath.row];
    cell.myMessage = message;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row pressed!!");
}



@end
