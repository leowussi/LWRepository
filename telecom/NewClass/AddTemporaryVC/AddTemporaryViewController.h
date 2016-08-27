//
//  AddTemporaryViewController.h
//  telecom
//
//  Created by 郝威斌 on 15/7/21.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "SXABaseViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
@interface AddTemporaryViewController : SXABaseViewController<AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    AVAudioRecorder *recorder;
    NSTimer *timer;
    NSURL *urlPlay;
    
}

@property (retain, nonatomic) AVAudioPlayer *avPlay;

@end
