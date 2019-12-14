//
//  NotificationService.m
//  FeidegouNotificationService
//
//  Created by Kite on 2019/12/14.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

//#import "NotificationService.h"
//
//@interface NotificationService ()
//
//@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
//@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;
//
//@end
//
//@implementation NotificationService
//
//- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
//    self.contentHandler = contentHandler;
//    self.bestAttemptContent = [request.content mutableCopy];
//
//    // Modify the notification content here...
//    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
//
//    self.contentHandler(self.bestAttemptContent);
//}
//
//- (void)serviceExtensionTimeWillExpire {
//    // Called just before the extension will be terminated by the system.
//    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
//    self.contentHandler(self.bestAttemptContent);
//}
//
//@end

#import "NotificationService.h"
#import <AVFoundation/AVFoundation.h>
 
#define kFileManager [NSFileManager defaultManager]
 
typedef void(^PlayVoiceBlock)(void);
 
@interface NotificationService ()<AVAudioPlayerDelegate>
 
@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;
//声音文件的播放器
@property (nonatomic, strong)AVAudioPlayer *myPlayer;
//声音文件的路径
@property (nonatomic, strong) NSString *filePath;
 
// 语音合成完毕之后，使用 AVAudioPlayer 播放
@property (nonatomic, copy)PlayVoiceBlock aVAudioPlayerFinshBlock;
 
@end
 
@implementation NotificationService
 
- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    
    __weak __typeof(self)weakSelf = self;
    
    /*******************************推荐用法*******************************************/
    
    // 方法3,语音合成，使用AVAudioPlayer播放,成功
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [self hechengVoiceAVAudioPlayerWithFinshBlock:^{
        weakSelf.contentHandler(weakSelf.bestAttemptContent);
    }];
//    self.contentHandler(self.bestAttemptContent);
}
 
#pragma mark- 合成音频使用 AVAudioPlayer 播放
- (void)hechengVoiceAVAudioPlayerWithFinshBlock:(PlayVoiceBlock )block
{
    if (block) {
        self.aVAudioPlayerFinshBlock = block;
    }
    
    /************************合成音频并播放*****************************/
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    NSArray *fileNameArray = @[@"daozhang",@"1",@"2",@"3",@"4",@"5",@"6",@"1",@"2",@"3",@"4",@"5",@"6",@"1",@"2",@"3",@"4",@"5",@"6"];
    
    CMTime allTime = kCMTimeZero;
    
    for (NSInteger i = 0; i < fileNameArray.count; i++) {
        NSString *auidoPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",fileNameArray[i]] ofType:@"m4a"];
        
        AVURLAsset *audioAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:auidoPath]];
        
        // 音频轨道
        AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:0];
        // 音频素材轨道
        AVAssetTrack *audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
        
        // 音频合并 - 插入音轨文件
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration) ofTrack:audioAssetTrack atTime:allTime error:nil];
        
        // 更新当前的位置
        allTime = CMTimeAdd(allTime, audioAsset.duration);
        
    }
    
    // 合并后的文件导出 - `presetName`要和之后的`session.outputFileType`相对应。
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetAppleM4A];
    NSString *outPutFilePath = [[self.filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"xindong.m4a"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPutFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:outPutFilePath error:nil];
    }
    
    // 查看当前session支持的fileType类型
    NSLog(@"---%@",[session supportedFileTypes]);
    session.outputURL = [NSURL fileURLWithPath:outPutFilePath];
    session.outputFileType = AVFileTypeAppleM4A; //与上述的`present`相对应
    session.shouldOptimizeForNetworkUse = YES;   //优化网络
    
    [session exportAsynchronouslyWithCompletionHandler:^{
        if (session.status == AVAssetExportSessionStatusCompleted) {
            NSLog(@"合并成功----%@", outPutFilePath);
            
            NSURL *url = [NSURL fileURLWithPath:outPutFilePath];
            
            self.myPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            
            self.myPlayer.delegate = self;
            [self.myPlayer play];
            
            
        } else {
            // 其他情况, 具体请看这里`AVAssetExportSessionStatus`.
            // 播放失败
            self.aVAudioPlayerFinshBlock();
        }
    }];
    
    /************************合成音频并播放*****************************/
}
#pragma mark- AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (self.aVAudioPlayerFinshBlock) {
        self.aVAudioPlayerFinshBlock();
    }
}
 
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer*)player error:(NSError *)error{
    //解码错误执行的动作
}
- (void)audioPlayerBeginInteruption:(AVAudioPlayer*)player{
    //处理中断的代码
}
- (void)audioPlayerEndInteruption:(AVAudioPlayer*)player{
    //处理中断结束的代码
}
 
- (NSString *)filePath {
    if (!_filePath) {
        _filePath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
        NSString *folderName = [_filePath stringByAppendingPathComponent:@"MergeAudio"];
        BOOL isCreateSuccess = [kFileManager createDirectoryAtPath:folderName withIntermediateDirectories:YES attributes:nil error:nil];
        if (isCreateSuccess) _filePath = [folderName stringByAppendingPathComponent:@"xindong.m4a"];
    }
    return _filePath;
}
- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
