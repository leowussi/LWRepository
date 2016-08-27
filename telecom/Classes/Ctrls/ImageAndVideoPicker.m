//
//  ImageAndVideoPicker.m
//  telecom
//
//  Created by SD0025A on 16/5/5.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "ImageAndVideoPicker.h"
#import "HWBProgressHUD.h"


@implementation ImageAndVideoPicker
- (void)pickImageFromPhotos
{
    self.TZI = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    self.TZI.allowPickingVideo = YES;
    self.TZI.allowPickingOriginalPhoto = NO;
    [self.ctrl presentViewController:self.TZI animated:YES completion:nil];
}
#pragma mark TZImagePickerControllerDelegate

// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    [self.delegate addImageFromTZI:photos];
   }


// 用户选择好了视频
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    TZImageManager *manager = [TZImageManager manager];
    [manager getVideoWithAsset:asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
        AVURLAsset * avAsset =(AVURLAsset *) playerItem.asset;
        NSURL *url = avAsset.URL;
        self.movieImage = coverImage;
        [self exchangeFormat:url];
        
    }];
    
 }

// 压缩视频
- (void)exchangeFormat:(NSURL *)url
{
    // 通过文件的 url 获取到这个文件的资源
    AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
    // 用 AVAssetExportSession 这个类来导出资源中的属性
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    // 压缩视频
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]) { // 导出属性是否包含低分辨率
        // 通过资源（AVURLAsset）来定义 AVAssetExportSession，得到资源属性来重新打包资源 （AVURLAsset, 将某一些属性重新定义
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetLowQuality];
        // 设置导出文件的存放路径
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        NSDate    *date = [[NSDate alloc] init];
        NSString *outPutPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"output-%@.mp4",[formatter stringFromDate:date]]];
        exportSession.outputURL = [NSURL fileURLWithPath:outPutPath];
        
        // 是否对网络进行优化
        exportSession.shouldOptimizeForNetworkUse = true;
        
        // 转换成MP4格式
        exportSession.outputFileType = AVFileTypeMPEG4;
        // 开始导出,导出后执行完成的block
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            // 如果导出的状态为完成
            if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    CGFloat size = [self getfileSize:exportSession.outputURL.path];
                    DLog(@"压缩数据后数据%f兆",size);
                    NSData *data = [NSData dataWithContentsOfURL:exportSession.outputURL];
                    [self.delegate addVedioFromTZI:data coverImage:self.movieImage];
                    
                });
            }
        }];
    }
}
//计算文件的大小
- (CGFloat)getfileSize:(NSString *)path
{
    NSDictionary *outputFileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSLog (@"file size: %f", (unsigned long long)[outputFileAttributes fileSize]/1024.00 /1024.00);
    return (CGFloat)[outputFileAttributes fileSize]/1024.00 /1024.00;
}
//制作视频的预览图
- (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath{
    
    UIImage *shotImage;
    //视频路径URL
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    shotImage = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return shotImage;
}

@end
