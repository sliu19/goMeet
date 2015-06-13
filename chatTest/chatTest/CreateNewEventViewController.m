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
#import "InviteFriendViewController.h"
#import "inviteFriendView.h"
#define inviteViewHeight 60.0

@interface CreateNewEventViewController()
@property (weak, nonatomic) IBOutlet UIScrollView *mainView;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *EventTitle;
@property (weak, nonatomic) IBOutlet UITextField *EventLocation;
@property (weak, nonatomic) IBOutlet UITextField *EventDescription;

@property (weak, nonatomic) IBOutlet UIButton *public;

@property (weak, nonatomic) IBOutlet UIButton *private;
@property (nonatomic, assign) UITextField* currentResponder;
@property (nonatomic,strong) NSString* PUBLIC;
@property (nonatomic,strong)NSString* uuid;
@property (nonatomic,strong)UIButton* publicButton;
@property (nonatomic,strong)UIButton* privateButton;
@property (nonatomic,strong)inviteFriendView* invitePicView;
@end


@implementation CreateNewEventViewController
@synthesize xmppStream;
@synthesize xmppRoom;
@synthesize xmppRoomStorage;
@synthesize publicButton;
@synthesize privateButton;
@synthesize invitePicView;

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_EventTitle setDelegate:self];
    [_EventLocation setDelegate:self];
    [_EventDescription setDelegate:self];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    singleTap.numberOfTapsRequired = 1;
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [_mainView setDelegate:self];
    CGSize contectSize  = _mainView.frame.size;
    _mainView.contentSize = contectSize;
    [self clearTextField];
    _private.tag = true;
    _public.tag = false;
    [_private addTarget:self action:@selector(AddEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_public addTarget:self action:@selector(AddEvent:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)clearTextField{
    if(_inviteList==nil){_inviteList = [[NSMutableArray alloc]init];}
    _EventDescription.text = @"";
    _EventTitle.text = @"";
    _EventLocation.text = @"";
}

#pragma Send event request
- (void)AddEvent:(id)sender {
    UIButton* clicked = (UIButton*) sender;
    BOOL private = clicked.tag;
    _PUBLIC = [NSString stringWithFormat:@"%s", (private ? "false" : "true")];
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString* uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    _uuid = uuidString;
    NSDate* now = _datePicker.date;
    int unixTime = [_datePicker.date timeIntervalSince1970];
    NSMutableArray* invitePic =[[NSMutableArray alloc]init];
    NSMutableArray* inviteID =[[NSMutableArray alloc]init];
    if (_inviteList!=nil) {
        for (Friend* friends in _inviteList) {
            [invitePic addObject:friends.userPic];
            [inviteID addObject:friends.userID];
        }
    }
    
    //Create Room
    //if (private) {
        xmppStream = [self appDelegate].xmppStream;
        [self initxmpproom:uuidString];
        //Setup local database
        EventList* event = nil;
        event = [NSEntityDescription insertNewObjectForEntityForName:@"EventList" inManagedObjectContext:[(AppDelegate*) [[UIApplication sharedApplication]delegate] managedObjectContext]];
        [event setValue: _EventDescription.text forKey :@"eventDescription"];
        [event setValue: uuidString forKey :@"jid"];
        [event setValue: _EventLocation.text forKey :@"location"];
        [event setValue: _EventTitle.text forKey :@"title"];
        [event setValue:now forKey:@"time"];
        [event setValue: invitePic forKey:@"groupMember"];
        [event setGroupMember:invitePic];
        NSLog(@"GroupMember when set is %@",[[NSString alloc] initWithData:event.groupMember_data encoding:NSUTF8StringEncoding]);
    
    //}
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //Also sent to server
    //newevent:{"description":"my description","title":"my event title4","event_id":"acf6830f-f945-11e4-a2bf-b8e85632007e","invite_list":[68958333],"location":"test event location4","time":1431503837791,"host_id":12341333,"public":false}
    //newPublicEvent:{"description":"my newsfeed event","title":"newfeed event","event_id":"47ec6551-fee1-11e4-b58d-a45e60c40087","start_time":1432120425578,"location":"newsfeed_event","host_id":111111111,"end_time":1432120435578}
    NSString *response=nil;
    if(!private){
         NSDictionary*dict = @{@"title":_EventTitle.text,@"event_id":uuidString,@"invite_list":inviteID,@"location":_EventLocation.text,@"start_time":[NSString stringWithFormat:@"%d", unixTime ],@"host_id":[prefs objectForKey:@"userID"],@"end_time":@"1432155744",@"description":_EventDescription.text,@"public":_PUBLIC,@"invite_list":inviteID};
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认发布实时活动" message:@"实时活动邀请的好友会在公告中看见您的活动" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];

        NSLog(@"public event");
        
        response  = [NSString stringWithFormat:@"newPublicEvent:%@",[Communication parseIntoJson:dict]];
    }
    else{
        //newevent
        NSLog(@"private event");
        NSDictionary*dict = @{@"title":_EventTitle.text,@"event_id":uuidString,@"invite_list":inviteID,@"location":_EventLocation.text,@"time":[NSString stringWithFormat:@"%d", unixTime ],@"host_id":[prefs objectForKey:@"userID"],@"description":_EventDescription.text,@"public":_PUBLIC,@"invite_list":inviteID};
        response  = [NSString stringWithFormat:@"newevent:%@",[Communication parseIntoJson:dict]];
    }
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [self clearTextField];
    [Communication send:data];
    NSError *error = nil;
    NSManagedObjectContext* selfManage = [(AppDelegate*) [[UIApplication sharedApplication]delegate] managedObjectContext];
    [selfManage save:&error];
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
    
    //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
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


- (IBAction)inviteFriend:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InviteFriendViewController *vc = (InviteFriendViewController *)[storyboard instantiateViewControllerWithIdentifier:@"InviteFriend"];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
     [vc setOrginalController:self];
    [privateButton removeFromSuperview];
    [publicButton removeFromSuperview];
    [invitePicView removeFromSuperview];
}


#pragma call back from invitefriend view
-(void)setFoo:(NSMutableArray *)inviteList{
    //NSLog(@"Desplay %@",inviteList);
    _inviteList = [[NSMutableArray alloc]initWithArray:inviteList];
    //integer round up
    int lines =1 + (int)([_inviteList count]-1)/5;
    CGSize viewSize = CGSizeMake(_mainView.frame.size.width, lines*inviteViewHeight);
    CGFloat viewOrigin = _datePicker.frame.origin.y + 180;
    invitePicView = [[inviteFriendView alloc]initWithFrame:CGRectMake(0, viewOrigin, viewSize.width, viewSize.height)];
    invitePicView.inviteList = _inviteList;
    invitePicView.backgroundColor = self.view.backgroundColor;
    [_mainView addSubview:invitePicView];
    if([_inviteList count]!=0){
        [self moveButton:viewSize.height+30];
    }
}

-(void)moveButton:(CGFloat)moveDistance{
    NSLog(@"ADDing scrolling view");
    CGRect publicFrame = _public.frame;
    CGRect privateFrame = _private.frame;
    CGSize mainFrameSize = _mainView.contentSize;
    //NSLog(@"contectSize is %f,publivButton position is %f",mainFrameSize.height,publicFrame.origin.y);
    publicFrame.origin.y += moveDistance;
    privateFrame.origin.y += moveDistance;
    privateButton = [self buttonDeepCopy: _private];
    privateButton.frame = privateFrame;
    publicButton = [self buttonDeepCopy: _public];
    publicButton.frame = publicFrame;
    privateButton.tag = true;
    publicButton.tag = false;
    [privateButton addTarget:self action:@selector(AddEvent:) forControlEvents:UIControlEventTouchUpInside];
    [publicButton addTarget:self action:@selector(AddEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:privateButton];
    [_mainView addSubview:publicButton];
    _mainView.contentSize = CGSizeMake(mainFrameSize.width,mainFrameSize.height+moveDistance);
    [_mainView setNeedsDisplay];
    _public.hidden = true;
    _private.hidden = true;
    publicButton.hidden = FALSE;

}

-(UIButton*)buttonDeepCopy:(UIButton*)originalButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = originalButton.frame;
    //[button addTarget:self
               //action:@selector(aMethod:)
     //forControlEvents:UIControlEventTouchUpInside];
    [button setTintColor:[UIColor whiteColor]];
    [button setTitle:originalButton.titleLabel.text forState:UIControlStateNormal];
    button.backgroundColor = originalButton.backgroundColor;
    //newButton.titleLabel.text= originalButton.titleLabel.text;
    button.titleLabel.attributedText = originalButton.titleLabel.attributedText;
    //newButton.titleLabel.textAlignment = originalButton.titleLabel.textAlignment;
    button.titleLabel.textColor = originalButton.titleLabel.textColor;
    return button;
}

#pragma outputstream handler
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
                            NSLog(@"server said: \"%@\", our uuid \"%@\"", [output uppercaseString],_uuid);
                            if ([[output uppercaseString] containsString:_uuid]) {
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

#pragma textField editor help

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
    [self animateTextField: textField up: YES];
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.currentResponder resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
    
}

- (void) animateTextField: (UITextField *)textField up: (BOOL) up
{
    CGPoint textFieldCenter = textField.center;
    CGPoint textPosition = [_currentResponder convertPoint:textFieldCenter fromView:self.mainView];
    //NSLog(@"POSITION IS %f",textPosition.y);
    const int movementDistance = -textPosition.y;; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
    // self.becomeFirstResponder();
}



@end
