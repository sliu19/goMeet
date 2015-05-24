//
//  SignUpViewController.m
//  chatTest
//
//  Created by Luyao Huang on 15/2/8.
//  Copyright (c) 2015年 LPP. All rights reserved.
//

#import "SignUpViewController.h"
#import "Communication.h"
#import "MainTabBarViewController.h"
#import "JFBCrypt.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *passCode;
@property (weak, nonatomic) IBOutlet UITextField *passCodeConfirm;
@property (weak, nonatomic) IBOutlet UIButton *signUp;
@property (weak, nonatomic) IBOutlet UILabel *outPut;
@property (nonatomic, assign) id currentResponder;
@property (weak, nonatomic) IBOutlet UIButton *gender_F;
@property (weak, nonatomic) IBOutlet UIButton *gender_M;
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (nonatomic,strong)NSString* gender;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[Communication initNetworkCommunication];
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    self.phoneNum.delegate = self;
    self.passCode.delegate = self;
    self.passCodeConfirm.delegate = self;
    self.nickName.delegate = self;
    self.gender = @"F";
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SignUp:(UIButton *)sender {
    if (_phoneNum.text == nil || _passCode.text ==nil ||_passCodeConfirm== nil) {
        _outPut.text = @"Incomplete Infomation!";
        _outPut.textColor = [UIColor redColor];
    }
    else{
        if ([_passCodeConfirm.text isEqualToString:_passCode.text]){
            
            //{"gender":"M","pass_hash":"password","phone_num":6505758649,"nick":"ZhouYi"}
            // [JFBCrypt hashPassword: password withSalt: salt]
            //NSString *salt = [JFBCrypt generateSaltWithNumberOfRounds: 10];
            NSDictionary* dict = @{@"gender":self.gender,@"pass_hash":_passCode.text,@"phone_num":self.phoneNum.text,@"nick":self.nickName.text};
            
            
            NSString *response  = [NSString stringWithFormat:@"reg:%@", [Communication parseIntoJson:dict]];
            NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
            [Communication send:data];
        }
        else{
            
            _outPut.text = @"Passcode mismatch!";
            NSLog(@"PASS, CONFIRM %@   %@",_passCode.text,_passCodeConfirm.text);
            _outPut.textColor = [UIColor redColor];
        }
    }
    
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}

//Implement resignOnTap:

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)gender_Female:(id)sender {
    self.gender_F.backgroundColor = [UIColor greenColor];
    self.gender_M.backgroundColor = [UIColor grayColor];
    self.gender = @"F";
}
- (IBAction)gender_Male:(id)sender {
    self.gender_M.backgroundColor = [UIColor greenColor];
    self.gender_F.backgroundColor = [UIColor grayColor];
    self.gender = @"M";

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
                                {
                                    NSLog(@"trigger segue");
                                    // Create strings and integer to store the text info
                                    NSString *userID = [_phoneNum text];
                                    NSString *userPassCode  = [_passCode text];
                                    NSString* nickName = [_nickName text];
                                    //int age = [[ageTextField text] integerValue];
                                    
                                    // Create instances of NSData
                                    UIImage *contactImage = [UIImage imageNamed:@"testImage.jpeg"];
                                    NSData *imageData = UIImageJPEGRepresentation(contactImage, 100);
                                    
                                    
                                    // Store the data
                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                    
                                    [defaults setObject:userID forKey:@"userID"];
                                    [defaults setObject:userPassCode forKey:@"passCode"];
                                    //[defaults setInteger:age forKey:@"age"];
                                    [defaults setObject:imageData forKey:@"userPic"];
                                    [defaults setObject:nickName forKey:@"nickName"];
                                    [defaults setObject:_gender forKey:@"gender"];
                                    [defaults synchronize];
                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                    MainTabBarViewController *viewController = (MainTabBarViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GoMeet"];
                                    [viewController setSelectedIndex:0];
                                    [self presentViewController:viewController animated:YES completion:nil];
                                    break;
                                }
                                    
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
            NSLog(@"Unknown event in Signup");
    }
    
}


@end
