//
//  EventListTableViewCell.m
//  chatTest
//
//  Created by Simin Liu on 4/22/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "EventListTableViewCell.h"


#define OFF_SET 10
#define HEIGHT 160
#define WEIGHT 320
#define TitleHeight 30
#define TitleWeight 300
@interface EventListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIView *gapView;

@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *mainViewLabel;
@property (weak, nonatomic) IBOutlet UIView *displayView;


@end



@implementation EventListTableViewCell

@synthesize myEvent;
//@synthesize backGroundColor;


-(void)awakeFromNib
{
    [self setup];
}


- (void)KKKsetSelected:(BOOL)selected animated:(BOOL)animated
{
    // Configure the view for the selected state
    
    // hear only you can manage your background views, simply i am adding 2 imageviews by setting different colors
    [super setSelected:selected animated:animated];
    //self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
    if(selected)
    {
        //self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
           }
    else
    {
       ;
    }
    
}

-(void)KKKKlayoutSubviews
{
    
    //i am setting the frame for each views that i hav added
    [super layoutSubviews];
    //self.label1.frame = CGRectMake(10, 10, 60, 35);
    //self.label2.frame = CGRectMake(65, 10, 60, 35);
    
}

-(void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    self.opaque = YES;
    _mainView.frame =CGRectMake(0, 0, self.frame.size.width,174);
    [_mainView addSubview:_cardView];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    
    //Optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    
    NSString *stringFromDate = [formatter stringFromDate:myEvent.time];
    
    _mainViewLabel.text = stringFromDate;

    self.contentMode = UIViewContentModeRedraw;
    
}



- (void)drawRect:(CGRect)rect {
    _Title.text = myEvent.title;
    //UIImage *testImage = [UIImage imageNamed:@"testImage.jpeg"];
    //test = UIImageJPEGRepresentation(testImage,testImage.scale);
    
   // UIImage *contentImage = [[UIImage alloc] initWithData:[news getContentImage:news]];
    //contentImage = [Communication imageWithImage:contentImage scaledToSize:CGSizeMake(self.bounds.size.width-2*OFFSET_FROM_FRAME,self.bounds.size.width-2*OFFSET_FROM_FRAME)];
    //UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(OFFSET_FROM_FRAME, OFFSET_FROM_FRAME, contentImage.size.width,contentImage.size.height )];
    //iv.contentMode = UIViewContentModeScaleAspectFit;
    //iv.image = contentImage;
    //[iv setImage:contentImage];
    //innerPoint.x = OFFSET_FROM_FRAME;
    //innerPoint.y = OFFSET_FROM_FRAME +contentImage.size.height;
    //UILabel* contentString = [[UILabel alloc]initWithFrame:CGRectMake(innerPoint.x, innerPoint.y, self.bounds.size.width-2*OFFSET_FROM_FRAME,20)];
    //contentString.text = [news getContentText:news];
    //contentString.font=[UIFont boldSystemFontOfSize:15.0];
    //contentString.textColor=[UIColor blackColor];
    //contentString.backgroundColor=[UIColor clearColor];
    //if((self.bounds.size.height - innerPoint.y)> OFFSET_FROM_FRAME ){[self addSubview:contentString];}
    //[self addSubview:iv];
}

- (IBAction)clickCalender:(id)sender {
    _contentImageView.image = [UIImage imageNamed:@"Date"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    
    //Optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    
    NSString *stringFromDate = [formatter stringFromDate:myEvent.time];

    _mainViewLabel.text = stringFromDate;
    
}


- (IBAction)clickLoaction:(id)sender {
    _contentImageView.image = [UIImage imageNamed:@"Check-in"];
    _mainViewLabel.text = myEvent.location;
}

- (IBAction)clickDescription:(id)sender {
    _contentImageView.image = [UIImage imageNamed:@"Description"];
    _mainViewLabel.text = myEvent.eventDescription;
}

- (IBAction)clickPeople:(id)sender {
    _contentImageView.image = [UIImage imageNamed:@"people"];
}






@end
