//
//  SignUpViewController.m
//  chatTest
//
//  Created by Luyao Huang on 15/2/8.
//  Copyright (c) 2015年 LPP. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *passCode;
@property (weak, nonatomic) IBOutlet UITextField *passCodeConfirm;
@property (weak, nonatomic) IBOutlet UIButton *signUp;
@property (weak, nonatomic) IBOutlet UILabel *outPut;
@property (nonatomic, assign) id currentResponder;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // [self initNetworkCommunication];
    self.phoneNum.delegate = self;
    self.passCode.delegate = self;
    self.passCodeConfirm.delegate = self;
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
            NSString *response  = [NSString stringWithFormat:@"reg:%@;%@" , _phoneNum.text,_passCode.text];
            NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
            //[Lib send:data];
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

@end
