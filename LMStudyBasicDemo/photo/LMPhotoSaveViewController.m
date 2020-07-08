//
//  LMPhotoSaveViewController.m
//  LMStudyBasicDemo
//
//  Created by liumiao on 2019/12/3.
//  Copyright © 2019 LM. All rights reserved.
//

#import "LMPhotoSaveViewController.h"
#import <Photos/Photos.h>

@interface LMPhotoSaveViewController ()

@end

@implementation LMPhotoSaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//1.先保存图片到【相机胶卷】(不能直接保存到自定义相册中)
//2.拥有一个【自定义相册】
//3.将刚才保存到【相机胶卷】里面的图片引用到【自定义相册】

#pragma mark - save image to photo

- (void)saveImageToPhoto:(UIImage *)image
{
//    注意：UIImageWriteToSavedPhotosAlbum方法必须实现 - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo 代理方法，否则会崩溃
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void * _Nullable)(self));
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
}

- (void)saveImageToPhotoSecondMethod:(UIImage *)image
{
    //保存图片到【相机胶卷】
    // 异步执行修改操作
    /*
    如果直接使用 [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image]; 则会出现如下的崩溃信息
    reason: 'This method can only be called from inside of -[PHPhotoLibrary performChanges:completionHandler:] or -[PHPhotoLibrary performChangesAndWait:error:]'
     */

    [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",@"保存失败");
        } else {
            NSLog(@"%@",@"保存成功");
        }
    }];
}

#pragma mark - 保存到自定义相册

- (void)saveImageToAppPhoto:(UIImage *)image
{
    // -------------------- 创建自定义相册 ------------------

    NSString *title = [NSBundle mainBundle].infoDictionary[(__bridge NSString*)kCFBundleNameKey];
    //查询所有【自定义相册】
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHAssetCollection *createCollection = nil;
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            createCollection = collection;
            break;
        }
    }
    if (createCollection == nil) {
        //当前对应的app相册没有被创建
        //创建一个【自定义相册】
        NSError *error = nil;
        __block NSString *createCollectionID = nil;
        [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
            //创建一个【自定义相册】
           createCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
        } error:&error];
        createCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createCollectionID] options:nil].firstObject;
    }
    NSLog(@"%@",createCollection);

    // -------------------- 保存图片 ------------------

    // 1.先保存图片到【相机胶卷】
    /// 同步执行修改操作
    NSError *error = nil;
    __block PHObjectPlaceholder *placeholder = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
       placeholder =  [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset;
    } error:&error];
    if (error) {
        NSLog(@"保存失败");
        return;
    }
    // 2.拥有一个【自定义相册】
    PHAssetCollection * assetCollection = createCollection;
    if (assetCollection == nil) {
        NSLog(@"创建相册失败");
        return;
    }
    // 3.将刚才保存到【相机胶卷】里面的图片引用到【自定义相册】
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        PHAssetCollectionChangeRequest *requtes = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
//        [requtes addAssets:@[placeholder]];
        // 【自定义相册】中新添加的图片便会作为相册的封面了
        [requtes insertAssets:@[placeholder] atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];

    if (error) {
        NSLog(@"保存图片失败");
    } else {
        NSLog(@"保存图片成功");
    }

    
}

- (void)getImageSize:(PHAsset *)asset
{

//    有时，在编辑照片后，会创建较小的版本。这仅适用于一些较大的照片。
//    在尝试检索已编辑的版本（）时，调用requestImageForAsset:（with PHImageManagerMaximumSize）或requestImageDataForAsset:（with PHImageRequestOptionsDeliveryModeHighQualityFormat）将从较小的文件版本中读取数据PHImageRequestOptionsVersionCurrent。
//    的info在上述方法回调将指向的路径图像。作为一个例子：
//    PHImageFileURLKey = "file:///[...]DCIM/100APPLE/IMG_0006/Adjustments/IMG_0006.JPG";
//    检查该文件夹，我能够找到另一个图像，FullSizeRender.jpg- 这个图像具有完整的大小并包含最新的编辑。因此，一种方法FullSizeRender.jpg是在存在这样的文件时尝试从中读取。
//    从iOS 9开始，还可以使用以下命令以最高分辨率获取最新编辑PHAssetResourceManager：


    // if (@available(iOS 9.0, *)) {
    // check if a high quality edit is available
    NSArray<PHAssetResource *> *resources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *hqResource = nil;
    for (PHAssetResource *res in resources) {
        if (res.type == PHAssetResourceTypeFullSizePhoto) {
            // from my tests so far, this is only present for edited photos
            hqResource = res;
            break;
        }
    }

    if (hqResource) {
        PHAssetResourceRequestOptions *options = [[PHAssetResourceRequestOptions alloc] init];
        options.networkAccessAllowed = YES;
        long long fileSize = [[hqResource valueForKey:@"fileSize"] longLongValue];
        NSMutableData *fullData = [[NSMutableData alloc] initWithCapacity:fileSize];

        [[PHAssetResourceManager defaultManager] requestDataForAssetResource:hqResource options:options dataReceivedHandler:^(NSData * _Nonnull data) {
            // append the data that we're receiving
            [fullData appendData:data];
        } completionHandler:^(NSError * _Nullable error) {
            // handle completion, using `fullData` or `error`
            // uti == hqResource.uniformTypeIdentifier
            // orientation == UIImageOrientationUp
        }];
    }
    else {
        // use `requestImageDataForAsset:`, `requestImageForAsset:` or `requestDataForAssetResource:` with a different `PHAssetResource`
    }
}

@end
