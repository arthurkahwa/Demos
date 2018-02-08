//
//  ViewController.m
//  Kahwa - Week 2 Assignment
//
//  Created by Arthur Nsereko Kahwa on 08/30/2017.
//  Copyright © 2017 Software Mill. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
-(void)say:(NSString *)message {
    NSLog(@"%@", message);
}

- (NSURL *)urlForSound:(NSString *)nameOfSound mediaOfType:(NSString *)typeOfMedia {
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:nameOfSound
                                                          ofType:typeOfMedia];

    return [NSURL fileURLWithPath:soundPath];;
}

- (void)soundBadAlert {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Could not load sound"
                                                            message:@"Sound problem"
                                                     preferredStyle:UIAlertControllerStyleAlert];

    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)isSoundGood:(SystemSoundID *)outSystemSoundID soundUrl:(NSURL *)soundUrl {
    BOOL soundIsGood;

    OSStatus statusReport = AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundUrl, outSystemSoundID);
    if (statusReport == kAudioServicesNoError) {
        soundIsGood = YES;
    }
    else {
        soundIsGood = NO;

        [self soundBadAlert];
    }

    return soundIsGood;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _startDate = [[NSDate alloc] init];
    [_indicator stopAnimating];

    _kickGood = [self isSoundGood:&_kickId
                         soundUrl:[self urlForSound:@"BassDrum"
                                          mediaOfType:@"aif"]];

    _clapGood = [self isSoundGood:&_clapId
                         soundUrl:[self urlForSound:@"HandClap"
                                          mediaOfType:@"aif"]];

    _claveGood = [self isSoundGood:&_claveId
                          soundUrl:[self urlForSound:@"Clave"
                                           mediaOfType:@"aif"]];

    _chimesGood = [self isSoundGood:&_chimesId
                           soundUrl:[self urlForSound:@"Chimes"
                                          mediaOfType:@"aif"]];

    NSURL *stevelandsUrl = [self urlForSound:@"StevelandsVinyl"
                                 mediaOfType:@"mp3"];
    NSError *err;
    _stevelandsVinyl = [[AVAudioPlayer alloc] initWithContentsOfURL:stevelandsUrl error:&err];
    if (!_stevelandsVinyl) {
        _stevelandsGood = NO;
        [self soundBadAlert];
    }
    else {
        _stevelandsGood = YES;
    }
    
}

- (IBAction)kick:(UIButton *)sender {

    if (_kickGood) {
        AudioServicesPlaySystemSound(_kickId);
    }
}

- (IBAction)clap:(UIButton *)sender {

    if (_clapGood) {
        AudioServicesPlaySystemSound(_clapId);
    }
}

- (IBAction)clave:(UIButton *)sender {

    if (_claveGood) {
        AudioServicesPlaySystemSound(_claveId);
    }
}

- (IBAction)chimes:(UIButton *)sender {

    if (_chimesGood) {
        AudioServicesPlaySystemSound(_chimesId);
    }
}

- (void)incrementTimer {

    NSDate *now = [[NSDate alloc] init];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger calenderUnitFlags = NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComparisonResult = [gregorianCalendar components:calenderUnitFlags
                                                                  fromDate:_startDate
                                                                    toDate:now
                                                                   options:0];

    NSInteger minutes = [dateComparisonResult minute];
    NSInteger seconds = [dateComparisonResult second];

    NSString *timerLabelText = [NSString stringWithFormat:@"%02ld:%02ld", minutes, seconds];
    _timerLabel.text = timerLabelText;
}

- (IBAction)startSteveland:(UIButton *)sender {
    if (_stevelandsGood) {
        [_indicator startAnimating];

        _timerLabel.hidden = NO;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(incrementTimer)
                                                userInfo:nil
                                                 repeats:YES];
        [_stevelandsVinyl play];
    }
}

- (IBAction)stopSteveland:(UIButton *)sender {
    if (_stevelandsGood) {
        [_indicator stopAnimating];

        _timerLabel.hidden = YES;

        [_timer invalidate];
        [_stevelandsVinyl stop];
    }
}

- (IBAction)resetTimer:(UIButton *)sender {
}

- (void)dealloc {
    if (_kickGood) {
        AudioServicesDisposeSystemSoundID(_kickId);
    }

    if (_clapGood) {
        AudioServicesDisposeSystemSoundID(_clapId);
    }

    if (_claveGood) {
        AudioServicesDisposeSystemSoundID(_claveId);
    }

    if (_chimesGood) {
        AudioServicesDisposeSystemSoundID(_chimesId);
    }
}
@end
