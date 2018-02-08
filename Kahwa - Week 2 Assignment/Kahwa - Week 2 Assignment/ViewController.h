//
//  ViewController.h
//  Kahwa - Week 2 Assignment
//
//  Created by Arthur Nsereko Kahwa on 08/30/2017.
//  Copyright © 2017 Software Mill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController

@property (assign, nonatomic) SystemSoundID kickId;
@property (assign, nonatomic) SystemSoundID clapId;
@property (assign, nonatomic) SystemSoundID claveId;
@property (assign, nonatomic) SystemSoundID chimesId;
@property (assign, nonatomic) BOOL kickGood;
@property (assign, nonatomic) BOOL clapGood;
@property (assign, nonatomic) BOOL claveGood;
@property (assign, nonatomic) BOOL chimesGood;
@property (assign, nonatomic) BOOL stevelandsGood;
@property (strong, nonatomic) AVAudioPlayer *stevelandsVinyl;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSDate *startDate;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

- (IBAction)kick:(UIButton *)sender;
- (IBAction)clap:(UIButton *)sender;
- (IBAction)clave:(UIButton *)sender;
- (IBAction)chimes:(UIButton *)sender;
- (IBAction)startSteveland:(UIButton *)sender;
- (IBAction)stopSteveland:(UIButton *)sender;

- (void)say:(NSString *)message;
- (NSURL *)urlForSound:(NSString *)nameOfSound
           mediaOfType:(NSString *)typeOfMedia;
- (void)soundBadAlert;
- (void)incrementTimer;
@end

