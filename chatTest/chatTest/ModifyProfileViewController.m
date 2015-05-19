//
//  ModifyProfileViewController.m
//  chatTest
//
//  Created by Simin Liu on 5/12/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "ModifyProfileViewController.h"
#import "Communication.h"
#import "MainTabBarViewController.h"


@interface ModifyProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UITextField *intro;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *location;
@property (weak, nonatomic) IBOutlet UIImageView *userPic;
@property (weak, nonatomic) IBOutlet UILabel *userID;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (nonatomic, assign) id currentResponder;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic) UIImagePickerController *imagePickerController;

@property (nonatomic, weak) NSTimer *cameraTimer;
@property (nonatomic) NSMutableArray *capturedImages;
@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *takePictureButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *startStopButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *delayedPhotoButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation ModifyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    _nickName.delegate = self;
    _intro.delegate =self;
    _email.delegate = self;
    _location.delegate = self;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    _nickName.text = [prefs objectForKey:@"nickName"];
    _intro.text = [prefs objectForKey:@"intro"];
    _email.text = [prefs objectForKey:@"email"];
    _location.text = [prefs objectForKey:@"location"];
    _userPic.image = [[UIImage alloc]initWithData:[prefs dataForKey:@"userPic"]];
    _userID.text = [prefs objectForKey:@"userID"];
    _gender.text = @"男";
    if ([[prefs stringForKey:@"gender"] isEqualToString:@"F"]){
        _gender.text = @"女";
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    singleTap.numberOfTapsRequired = 1;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changePic:(id)sender {
}
- (IBAction)confirm:(id)sender {
    //profile:{"phone":6505758649,"nick":"mynickname","intro":"password","location":"mylocation","pass":"mypassword","email":"myemail"} only phoneNumberrequired
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = @{@"phone":[prefs objectForKey:@"userID"],@"intro":_intro.text,@"nick":_nickName.text,@"location":_location.text,@"email":_email.text};
    NSString *response  = [NSString stringWithFormat:@"profile:%@",[Communication parseIntoJson:dict]];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];
}
- (IBAction)chageProfilePic:(id)sender {
    UIImage* image = _userPic.image;
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
    imageCropVC.delegate = self;
    [self.navigationController pushViewController:imageCropVC animated:YES];
    
}

- (IBAction)showImagePickerForCamera:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}


- (IBAction)showImagePickerForPhotoPicker:(id)sender
{
    NSLog(@"start pick pics");
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
}


- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if (self.capturedImages.count > 0)
    {
        [self.capturedImages removeAllObjects];
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        /*
         The user wants to use the camera interface. Set up our custom overlay view for the camera.
         */
        imagePickerController.showsCameraControls = NO;
        
        /*
         Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
         */
        [[NSBundle mainBundle] loadNibNamed:@"LaunchScreen" owner:self options:nil];
        self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
        imagePickerController.cameraOverlayView = self.overlayView;
        self.overlayView = nil;
    }
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}


#pragma mark - Toolbar actions

- (IBAction)done:(id)sender
{
    // Dismiss the camera.
    if ([self.cameraTimer isValid])
    {
        [self.cameraTimer invalidate];
    }
    [self finishAndUpdate];
}


- (IBAction)takePhoto:(id)sender
{
    [self.imagePickerController takePicture];
}




- (IBAction)stopTakingPicturesAtIntervals:(id)sender
{
    // Stop and reset the timer.
    [self.cameraTimer invalidate];
    self.cameraTimer = nil;
    
    [self finishAndUpdate];
}


- (void)finishAndUpdate
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if ([self.capturedImages count] > 0)
    {
        if ([self.capturedImages count] == 1)
        {
            // Camera took a single picture.
            [self.imageView setImage:[self.capturedImages objectAtIndex:0]];
        }
        else
        {
            // Camera took multiple pictures; use the list of images for animation.
            self.imageView.animationImages = self.capturedImages;
            self.imageView.animationDuration = 5.0;    // Show each captured photo for 5 seconds.
            self.imageView.animationRepeatCount = 0;   // Animate forever (show all photos).
            [self.imageView startAnimating];
        }
        
        // To be ready to start again, clear the captured images array.
        [self.capturedImages removeAllObjects];
    }
    
    self.imagePickerController = nil;
}


#pragma mark - Timer

// Called by the timer to take a picture.
- (void)timedPhotoFire:(NSTimer *)timer
{
    [self.imagePickerController takePicture];
}


#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"didFinishPicking pic");
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //_imageView.image = image;
    [self.capturedImages addObject:image];
    
    if ([self.cameraTimer isValid])
    {
        NSLog(@"return here");
        return;
    }
    
    [self finishAndUpdate];
    //UIImage *image = _imageView.image;
    //RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
    // imageCropVC.delegate = self;
    // [self.navigationController pushViewController:imageCropVC animated:NO];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    //[_uiView setNeedsDisplay];
}

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
    //[_uiView setNeedsDisplay];
}

// The original image has been cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
{
    self.imageView.image = croppedImage;
    _imageView.image = croppedImage;
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image has been cropped. Additionally provides a rotation angle used to produce image.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
                  rotationAngle:(CGFloat)rotationAngle
{
    self.imageView.image = croppedImage;
    _imageView.image = croppedImage;
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image will be cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                  willCropImage:(UIImage *)originalImage
{
    // Use when `applyMaskToCroppedImage` set to YES.
    //[SVProgressHUD show];
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
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding];
                        
                        if (nil != output) {
                            switch (output.intValue) {
                                case 1:
                                {
                                    NSLog(@"successful modifile");
                                    //6505758649,"nick":"mynickname","intro":"password","location":"mylocation","pass":"mypassword","email":"myemail"} only phoneNumberrequired
            
                                    // Create instances of NSData
                                    UIImage *contactImage = [UIImage imageNamed:@"testImage.jpeg"];
                                    NSData *imageData = UIImageJPEGRepresentation(contactImage, 100);
                                    
                                    
                                    // Store the data
                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                    
                                    [defaults setObject:[_nickName text] forKey:@"nickName"];
                                    [defaults setObject:[_intro text] forKey:@"intro"];
                                    [defaults setObject:[_location text] forKey:@"location"];
                                    [defaults setObject:[_email text]forKey:@"email"];
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
