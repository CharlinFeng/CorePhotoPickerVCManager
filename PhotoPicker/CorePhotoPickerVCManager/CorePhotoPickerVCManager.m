//
//  CorePhotoPickerVC.m
//  PhotoPicker
//
//  Created by muxi on 15/2/13.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "CorePhotoPickerVCManager.h"
#import "UzysAssetsPickerController.h"

@interface CorePhotoPickerVCManager ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UzysAssetsPickerControllerDelegate>

@property (nonatomic,strong) UzysAssetsPickerController *multiPickerVC;                                 //相册多选控制器

@end

@implementation CorePhotoPickerVCManager


/**
 *  根据type创建对应的照片选择器
 */
+(instancetype)pickerVCWithPikerType:(CorePhotoPickerType)pikerType{
    
    CorePhotoPickerVCManager *pickerTool=[[CorePhotoPickerVCManager alloc] init];
    
    pickerTool.pikerType=pikerType;

    return pickerTool;
}

-(UIViewController *)pickerVCWithType:(CorePhotoPickerType)pikerType{
    
    UIViewController *pickerVC=nil;
    
    switch (pikerType) {
        case CorePhotoPickerTypeCamera://拍摄
        case CorePhotoPickerTypeSinglePhoto:
            pickerVC=[self systemPicker];
            break;
            
        default:
            pickerVC=self.multiPickerVC;
            break;
    }
    
    return pickerVC;
}



-(void)setMaxSelectedPhotoNumber:(NSInteger)maxSelectedPhotoNumber{
    
    if(maxSelectedPhotoNumber<=0) return;
    
    //记录
    _maxSelectedPhotoNumber=maxSelectedPhotoNumber;
    
    //设置
    self.multiPickerVC.maximumNumberOfSelectionPhoto=maxSelectedPhotoNumber;
}



#pragma mark  使用框架选取多疑图片:懒加载
-(UIViewController *)multiPickerVC{
    
    if(!_multiPickerVC){
        
        _multiPickerVC=[[UzysAssetsPickerController alloc] init];
        
        //暂不支持选视频
        _multiPickerVC.maximumNumberOfSelectionVideo=0;
        //初始化最大允许选取的图片数量
        _multiPickerVC.maximumNumberOfSelectionPhoto=MAXFLOAT;
        //设置代理
        _multiPickerVC.delegate=self;
    }
    
    return _multiPickerVC;
}



#pragma mark  使用系统的方法选取单张图片
-(UIViewController *)systemPicker{
    
    UIImagePickerControllerSourceType sourceType =(CorePhotoPickerTypeCamera==self.pikerType)?UIImagePickerControllerSourceTypeCamera:UIImagePickerControllerSourceTypePhotoLibrary;
    
    BOOL available = [UIImagePickerController isSourceTypeAvailable:sourceType];
    
    if(!available){
        
        self.unavailableType=(CorePhotoPickerTypeCamera==self.pikerType)?CorePhotoPickerUnavailableTypeCamera:CorePhotoPickerUnavailableTypePhoto;
        
        return nil;
    }
    
    UIImagePickerController *pickerVC=[[UIImagePickerController alloc] init];
    
    //允许编辑
    pickerVC.allowsEditing=YES;
    
    //设置模式
    pickerVC.sourceType=sourceType;
    
    //设置代理
    pickerVC.delegate=self;

    return pickerVC;
}


-(UIViewController *)pickerVC{
    
    return [self pickerVCWithType:self.pikerType];
}









#pragma mark  -系统自带控制器选取相册代理方法区
#pragma mark  选取了照片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //关闭自己
    [self.pickerVC dismissViewControllerAnimated:YES completion:^{
        
        CorePhoto *photo=[CorePhoto photoWithInfoDict:info];
        
        if(self.finishPickingMedia != nil) _finishPickingMedia(@[photo]);
    }];
}

#pragma mark  点击了取消按钮
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    //直接取消
    [self.pickerVC dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 多选代理方法区

-(void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{

    //获取相册数组
    NSArray *photos=[CorePhoto photosWithAssets:assets];
    
    if(self.finishPickingMedia != nil) _finishPickingMedia(photos);
}

#pragma mark  超过选取上限
-(void)uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker{
    NSLog(@"超过选取上限");
}

#pragma mark  取消
-(void)uzysAssetsPickerControllerDidCancel:(UzysAssetsPickerController *)picker{
    //直接取消：无需操作
}






@end
