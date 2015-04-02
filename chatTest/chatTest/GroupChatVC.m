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

@end

@implementation GroupChatVC

@synthesize xmppRoomStorage;
@synthesize xmppRoom;
@synthesize xmppStream;
@synthesize eventElement;

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


   
}

-(void)initxmpproom{
    //TO DO: Get response from server
    //[self getrooms];
    xmppRoomStorage  = [XMPPRoomCoreDataStorage sharedInstance];
    XMPPJID *roomJID = [XMPPJID jidWithString:eventElement.jid];
    xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:xmppRoomStorage jid:roomJID];
    [xmppRoom activate:xmppStream];
    [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //加入房间
    [self joinroom];
}

-(void)joinroom{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [xmppRoom joinRoomUsingNickname:[defaults stringForKey:@"userID"] history:nil];
}



-(void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID{
    NSLog(@"群发言了。。。。");
    
    NSString *type = [[message attributeForName:@"type"] stringValue];
    if ([type isEqualToString:@"groupchat"]) {
        NSString *msg = [[message elementForName:@"body"] stringValue];
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
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:message];
        
        //生成XML消息文档
        NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
        
        //消息类型
        [mes addAttributeWithName:@"type" stringValue:@"groupchat"];
        
        //发送给谁
        [mes addAttributeWithName:@"to" stringValue:CHATROOM];
        
        //由谁发送
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [mes addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@/%@",CHATROOM,[defaults stringForKey:@"userID"]]];
        
        //组合
        [mes addChild:body];
        
        //发送消息
        [xmppStream sendElement:mes];
        NSLog(@"Send message: %@",mes);
        
    }
}

-(void)newMessageReceived:(NSDictionary *)messageContent{
    //[arr1 addObject:messageContent];
    //[self.tableview1 reloadData];
    
    //if (self.tableview1.contentSize.height > self.tableview1.frame.size.height) {
      //  [self.tableview1 setContentOffset:CGPointMake(0, self.tableview1.contentSize.height - self.tableview1.frame.size.height)];
   // }
    
    NSLog(@"receive message %@", messageContent);
}


- (void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *)roomJID didReceiveInvitation:(XMPPMessage *)message{};
- (void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *)roomJID didReceiveInvitationDecline:(XMPPMessage *)message{};



- (void)viewWillDisappear:(BOOL)animated
{
    [[self appDelegate] disconnect];
    [[[self appDelegate] xmppvCardTempModule] removeDelegate:self];
    
    [super viewWillDisappear:animated];
}




-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    NSLog(@"textFieldShouldEdit");
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"textFieldDidBeginEdit");
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
    [viewController setSelectedIndex:3];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
