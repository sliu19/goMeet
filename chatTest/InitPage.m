//
//  InitPage.m
//  chatTest
//
//  Copyright (c) 2015年 LPP. All rights reserved.
//

#import "InitPage.h"
#import "MainTabBarViewController.h"
#import <Parse/Parse.h>
#import "Friend.h"
#import "AppDelegate.h"

@interface InitPage ()

@property (weak, nonatomic) IBOutlet UIButton *joinView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *passCode;
@property (nonatomic, assign) UITextField* currentResponder;
@property (weak, nonatomic) IBOutlet UIButton *logIn;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
@property (strong,nonatomic) NSArray* friendList;



@end

@implementation InitPage

- (void)viewDidLoad {
    [super viewDidLoad];
    //Send through NSStrem
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [Communication initNetworkCommunication];
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    _passCode.secureTextEntry= true;
    NSLog(@"InitPage");
    [self phoneNum].delegate= self;
    [self passCode].delegate = self;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    singleTap.numberOfTapsRequired = 1;
    _logIn.layer.cornerRadius = 5;
    _logIn.clipsToBounds = YES;
    _switchButton.layer.cornerRadius = 5;
    _switchButton.clipsToBounds = YES;
    _friendList = [[NSArray alloc]init];
    // Do any additional setup after loading the view from its nib.
}


-(void) viewDidAppear:(BOOL)animated{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* userId = [prefs stringForKey:@"userID"];
    NSLog(@"UserDefault data userID is %@",userId);
    if (userId!=nil) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainTabBarViewController *viewController = (MainTabBarViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GoMeet"];
        [viewController setSelectedIndex:0];
        [self presentViewController:viewController animated:NO completion:nil];

    }
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
}


- (IBAction)logIn:(id)sender {
    //log:{"phone":6505758649,"pass":"password"}
    NSDictionary* dict = @{@"phone":_phoneNum.text,@"pass":_passCode.text};
    NSString *response  = [NSString stringWithFormat:@"log:%@",[Communication parseIntoJson:dict]];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];
    //getfriends:6505758649
    NSLog(@"send login");
}


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
    CGPoint textPosition = [_currentResponder convertPoint:textFieldCenter fromView:self.view];
    NSLog(@"POSITION IS %f",textPosition.y);
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
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
                        NSData* pullFriend = [[NSData alloc]initWithBytes:buffer length:len];
                        if (nil!= output) {
                            NSLog(@"server said: !%@!", output);
                            if ([output isEqualToString:@"0\n"]) {
                                NSLog(@"Can not login!");
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆失败" message:@"密码输错了嘛？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                                // optional - add more buttons:
                                //[alert addButtonWithTitle:@"再试一次"];
                                [alert show];
                                
                                break;
                            }
                            if (1==output.intValue) {
                                NSLog(@"Find user");
                                NSString *response  = [NSString stringWithFormat:@"seekuser:%@",_phoneNum.text];
                                NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
                                [Communication send:data];
                                break;

                            }
                            else{
                                NSDictionary*result = [Communication parseFromJson:pullFriend ];
                                NSLog(@"OUTPUT is %@",result);
                                
                                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                                NSString* userId = [prefs stringForKey:@"userID"];
                                
                                //INPUT :seekuser:6505758649
                                //OUTPUT : {"introduction":"password","email":"myemail","nickname":"mynickname","location":"mylocation","is_male":true}
                                if(userId==nil){
                                    NSLog(@"successful Login");
                                    NSString *response2  = [NSString stringWithFormat:@"getfriends:%@",_phoneNum.text];
                                    NSData *data2 = [[NSData alloc] initWithData:[response2 dataUsingEncoding:NSUTF8StringEncoding]];
                                    [Communication send:data2];
                                    
                                    NSString *userID = [_phoneNum text];
                                    NSString *userPassCode  = [_passCode text];
                                    NSDictionary * userInfo = [Communication parseFromJson:[output dataUsingEncoding:NSUTF8StringEncoding]];
                                    NSLog(@"userInfo %@",userInfo);
                                    // Store the data
                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                    
                                    [defaults setObject:userID forKey:@"userID"];
                                    [defaults setObject:userPassCode forKey:@"passCode"];
                                    if(![[userInfo objectForKey:@"introduction"] isEqual:[NSNull null]]){
                                        [defaults setObject:[userInfo objectForKey:@"introduction"] forKey:@"intro"];}
                                    if(![[userInfo objectForKey:@"email"]isEqual:[NSNull null]]){
                                        [defaults setObject:[userInfo objectForKey:@"email"] forKey:@"email"];}
                                    if(![[userInfo objectForKey:@"location"] isEqual:[NSNull null]]){
                                        [defaults setObject:[userInfo objectForKey:@"location"] forKey:@"location"];}
                                    [defaults setObject:[userInfo objectForKey:@"nickname"] forKey:@"nickName"];
                                    [defaults setObject:[userInfo objectForKey:@"parseID"] forKey:@"parseID"];
                                    PFQuery *query = [PFQuery queryWithClassName:@"People"];
                                    [query getObjectInBackgroundWithId:[userInfo objectForKey:@"parseID"] block:^(PFObject *user, NSError *error) {
                                        // Do something with the returned PFObject in the gameScore variable.
                                        NSData* imgData =[user[@"smallPicFile"] getData];
                                        [defaults setObject: imgData forKey:@"userPic"];
                                    }];
                                    [defaults setObject:@"F" forKey:@"gender"];
                                    
                                    NSNumber* isMale =(NSNumber*)[userInfo objectForKey:@"is_male"];
                                    if ([isMale boolValue]==YES) {
                                        [defaults setObject:@"M" forKey:@"gender"];
                                    }
                                    [defaults synchronize];
                                    break;
                                }
                                else if ([result objectForKey:@"friends"]!=nil) {
                                    NSDictionary* dict = @{@"seekList":[result objectForKey:@"friends"]};
                                    _friendList =[result objectForKey:@"friends"];
                                    NSString *response  = [NSString stringWithFormat:@"multiseekuser:%@",[Communication parseIntoJson:dict]];
                                    NSLog(@"Asked multifriend %@",response);
                                    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
                                    [Communication send:data];
                                }
                                else if([result objectForKey:@"multiSeekDict"]!=nil){
                                    NSDictionary* userInfoList =[result objectForKey:@"multiSeekDict"];
                                    NSLog(@"multisuerlist is %@",userInfoList);
                                    for (NSDictionary* account in[userInfoList allValues]){
                                        PFQuery *query = [PFQuery queryWithClassName:@"People"];
                                        [query getObjectInBackgroundWithId:[account objectForKey:@"parseID"] block:^(PFObject *user, NSError *error) {
                                            // Do something with the returned PFObject in the gameScore variable.
                                            NSLog(@"FriendInfo is %@",account);
                                            NSData* imgData =[user[@"smallPicFile"] getData];
                                            [Communication addFriend:account :imgData];
                                        }];
                                    }
                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                    MainTabBarViewController *viewController = (MainTabBarViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GoMeet"];
                                    [viewController setSelectedIndex:0];
                                    [self presentViewController:viewController animated:YES completion:nil];
                                    break;

                                    
                                }
                                break;
                            }
                            break;
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
