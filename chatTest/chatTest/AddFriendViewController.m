//
//  AddFriend.m
//  chatTest
//
//  Created by Simin Liu on 3/16/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "AddFriendViewController.h"
#import "MainTabBarViewController.h"
#import "Communication.h"
#import <Parse/Parse.h>

@interface AddFriendViewController ()

@property (nonatomic, assign) UITextField* currentResponder;
@property (weak, nonatomic) IBOutlet UIView *resultView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UITextField *MessageTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmSearch;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (strong,nonatomic) NSString* newfriend;
@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[Communication initNetworkCommunication];
    [_MessageTextField setDelegate:self];
    [_searchTextField setDelegate:self];
     NSLog(@"AddFriendPage");
    _searchTextField.delegate = self;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    singleTap.numberOfTapsRequired = 1;
    _searchTextField.delegate = self;
    _resultView.hidden = YES;
    _userImage.layer.cornerRadius = _userImage.frame.size.width / 2;
    _userImage.clipsToBounds = YES;

}
-(void)viewDidAppear:(BOOL)animated{
    _resultView.hidden = YES;
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)searchPeople:(id)sender {
    _newfriend = _searchTextField.text;
    NSLog(@"searchNumber is :%@:",_newfriend);
    //seekuser:6505758649
    NSString* response = [NSString stringWithFormat:@"seekuser:%@",_newfriend];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];
}



- (IBAction)sendRequest:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //Send through NSStrem
    //addfriend:6505758649#1234567899
    NSString* userId = [prefs stringForKey:@"userID"];
    //addfriend:{"src_user":12341234,"msg":"omg my message","dst_user":68958695}
    NSDictionary* dict = @{@"src_user":userId,@"msg":_MessageTextField.text,@"dst_user":_searchTextField.text};
    NSString* response = [NSString stringWithFormat:@"addfriend:%@",[Communication parseIntoJson:dict]];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已发送申请" message:@"等待对方确认" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alert show];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainTabBarViewController *viewController = (MainTabBarViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GoMeet"];
    [viewController setSelectedIndex:3];
    [self presentViewController:viewController animated:YES completion:nil];
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
    const int movementDistance = -textPosition.y/2; // tweak as needed
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
                NSInteger len;
                
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding];
                        if (nil != output) {
                            if ([output  isEqualToString:@"{}\n"]) {
                                NSLog(@"Can not find user!");
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"找不到用户" message:@"账号输错了嘛？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                                [alert show];
                                break;
                            }
                            NSDictionary * userInfo = [Communication parseFromJson:[output dataUsingEncoding:NSUTF8StringEncoding]];
                            NSLog(@"userInfo %@",userInfo);
                            //OUTPUT : {"introduction":"password","email":"myemail","nickname":"mynickname","location":"mylocation","is_male":true}
                            _nameLabel.text = [userInfo objectForKey:@"nickname"];
                            if ([userInfo objectForKey:@"location"]!=nil) {
                                _locationLabel.text = [userInfo objectForKey:@"location"];
                            }
                            if([userInfo objectForKey:@"introduction"]!=nil){
                                _introLabel.text = [userInfo objectForKey:@"introduction"];
                            }
                            PFQuery *query = [PFQuery queryWithClassName:@"People"];
                            PFObject*user = [query getObjectWithId:[userInfo objectForKey:@"parseID"]];                                NSLog(@"return from PARSE");
                                NSData* imgData =[user[@"smallPicFile"] getData];
                                _userImage.image = [UIImage imageWithData:imgData];
                               // _resultView.hidden = false;

                           
                            NSLog(@"server said: %@", output);
                        }
                        
                            
                    }
                }
            }
            break;
            
        case NSStreamEventErrorOccurred:
        {
            NSLog(@"Can not connect to the host!");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"链接不上服务器" message:@"稍微晚些时候试试吧？" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
