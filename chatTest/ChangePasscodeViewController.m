//
//  ChangePasscodeViewController.m
//  赢家
//
//  Created by Simin Liu on 5/29/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "ChangePasscodeViewController.h"
#import "MainTabBarViewController.h"
#import "Communication.h"

@interface ChangePasscodeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPassCode;

@property (weak, nonatomic) IBOutlet UITextField *createPass;

@property (weak, nonatomic) IBOutlet UITextField *confirm;

@property (nonatomic, assign) id currentResponder;
@end

@implementation ChangePasscodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    singleTap.numberOfTapsRequired = 1;
    [_oldPassCode setDelegate:self];
    [_createPass setDelegate:self];
    [_confirm setDelegate:self];
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    _oldPassCode.secureTextEntry = true;
    _createPass.secureTextEntry = TRUE;
    _confirm.secureTextEntry = TRUE;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)confrim:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([_confirm.text isEqualToString:_createPass.text]) {
        if ([_oldPassCode.text isEqualToString:[defaults objectForKey:@"passCode"]]) {
            NSDictionary* dict = @{@"phone":[defaults objectForKey:@"userID"],@"pass":_confirm.text};
            NSString *response  = [NSString stringWithFormat:@"profile:%@",[Communication parseIntoJson:dict]];
            NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
            [Communication send:data];
            
        }else{
            NSLog(@"Wrong PassCode");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码错啦" message:@"换个密码试试？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            // optional - add more buttons:
            //[alert addButtonWithTitle:@"Yes"];
            [alert show];
            _oldPassCode.text = @"";
        }
    }else{
        NSLog(@"new PassCode no match");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新密码不一致" message:@"重新确认一下" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        // optional - add more buttons:
        //[alert addButtonWithTitle:@"Yes"];
        [alert show];
        _confirm.text = @"";
        _createPass.text = @"";
    }
}


-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.currentResponder resignFirstResponder];
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
                        
                        if (nil != output) {
                            switch (output.intValue) {
                                case 1:
                                {
                                    NSLog(@"successful modifile password");
                                    // Store the data
                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                    [defaults setObject:_confirm.text forKey:@"passCode"];
                                    [defaults synchronize];
                                    
                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                    MainTabBarViewController *viewController = (MainTabBarViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GoMeet"];
                                    [viewController setSelectedIndex:1];
                                    [self presentViewController:viewController animated:YES completion:nil];
                                    break;
                                }
                                    
                                default:
                                    NSLog(@"output int val %d", output.intValue);
                                    break;
                            }
                            NSLog(@"server said: %@", output);
                            
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
