//
//  CorePhotoPickerVC.h
//  PhotoPicker
//
//  Created by muxi on 15/2/13.
//  Copyright (c) 2015年 muxi. All rights reserved.
//  照片选取控制器

#import <UIKit/UIKit.h>
#import "CorePhoto.h"

typedef enum{
    
    CorePhotoPickerTypeCamera=0,                                                            //用户拍照
    
    CorePhotoPickerTypeSinglePhoto,                                                         //单张照片选取
    
    CorePhotoPickerTypeMultiPhoto,                                                          //多张照片选取
    
    CorePhotoPickerTypeVideo,                                                               //视频选取（暂不考虑，本框架仍可以完美支持）
    
    
}CorePhotoPickerType;



typedef enum{
    
    CorePhotoPickerUnavailableTypeNone,                                                     //无错误
    
    CorePhotoPickerUnavailableTypeCamera,                                                   //相机不可用
    
    CorePhotoPickerUnavailableTypePhoto,                                                    //相册不可用
    
}CorePhotoPickerUnavailableType;




typedef void(^FinishPickingMedia)(NSArray *medias);






@interface CorePhotoPickerVCManager : NSObject


@property (nonatomic,assign) CorePhotoPickerType pikerType;                                 //照片选取器类型

@property (nonatomic,assign) CorePhotoPickerUnavailableType unavailableType;                //照片选取器不可用类型

@property (nonatomic,strong) UIViewController *pickerVC;                                    //照片选取控制器

@property (nonatomic,copy) FinishPickingMedia finishPickingMedia;                           //选取结束block



/**
 *  多选参数，单行此属性将自动忽略
 *  此属性=0，表示不限制
 */
@property (nonatomic,assign) NSInteger maxSelectedPhotoNumber;                               //最多可选取的照片数量


/**CorePhotoPickerTool
 *  根据type创建对应的照片选择器
 */
+(instancetype)pickerVCWithPikerType:(CorePhotoPickerType)pikerType;


@end
