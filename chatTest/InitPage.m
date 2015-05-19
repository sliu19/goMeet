//
//  InitPage.m
//  chatTest
//
//  Copyright (c) 2015年 LPP. All rights reserved.
//

#import "InitPage.h"
#import "MainTabBarViewController.h"

@interface InitPage ()

@property (weak, nonatomic) IBOutlet UIButton *joinView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *passCode;
@property (nonatomic, assign) id currentResponder;
@property (weak, nonatomic) IBOutlet UIButton *logIn;




@end

@implementation InitPage

- (void)viewDidLoad {
    [super viewDidLoad];
    //Send through NSStrem
    [Communication initNetworkCommunication];
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    NSLog(@"InitPage");
    [self phoneNum].delegate= self;
    [self passCode].delegate = self;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    singleTap.numberOfTapsRequired = 1;
    
    

    
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
}


- (IBAction)logIn:(id)sender {
    //log:{"phone":6505758649,"pass":"password"}
    NSDictionary* dict = @{@"phone":_phoneNum.text,@"pass":_passCode.text};
    NSString *response  = [NSString stringWithFormat:@"log:%@",[Communication parseIntoJson:dict]];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];
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
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output) {
                            switch (output.intValue) {
                                case 1:
                                {
                                    NSLog(@"successful Login");
                                    NSString *userID = [_phoneNum text];
                                    NSString *userPassCode  = [_passCode text];
                                    // Create instances of NSData
                                    UIImage *contactImage = [UIImage imageNamed:@"testImage.jpeg"];
                                    NSData *imageData = UIImageJPEGRepresentation(contactImage, 100);
                                    
                                    
                                    // Store the data
                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                    
                                    [defaults setObject:userID forKey:@"userID"];
                                    [defaults setObject:userPassCode forKey:@"passCode"];
                                    [defaults setObject:@"F" forKey:@"gender"];
                                    [defaults setObject:@"testNickName" forKey:@"nickName"];
                                    [defaults setObject:imageData forKey:@"userPic"];
                                    [defaults synchronize];

                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                    MainTabBarViewController *viewController = (MainTabBarViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GoMeet"];
                                    [viewController setSelectedIndex:0];
                                    [self presentViewController:viewController animated:YES completion:nil];                                    break;
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
            NSLog(@"Unknown event");
    }
    
}



@end
