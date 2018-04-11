//
//  UIImagePicker.m
//  FuseGallery
//
//  Created by Mhd Mansour on 4/11/18.
//  Copyright © 2018 Mhd Mansour. All rights reserved.
//

#import "MissionXImagePicker.h"

@interface MissionXImagePicker() <TZImagePickerControllerDelegate>

@end

@implementation MissionXImagePicker

-(id)initWithRootViewController:(UIViewController*)viewController{
    NSLog(@"Initialized");

    if ((self = [super init])) {
        self.viewController = viewController;
    }

    return self;

}

- (void) launchPicker{

    TZImagePickerController* picker = [[TZImagePickerController alloc] initWithMaxImagesCount:10 delegate:self];
    picker.allowPickingVideo = NO;
    picker.allowTakePicture = NO;

    [self.viewController presentViewController:picker animated:YES completion:nil];


    self.picker = picker;

}

-(NSString*)convertToJson:(NSMutableArray*)paths {

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paths options:NSJSONWritingPrettyPrinted error:nil];


    return [[NSString alloc] initWithData:jsonData encoding:NSASCIIStringEncoding];

}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{

    NSLog(@"Number of images slected by user are %lu", (unsigned long)[photos count]);
    NSMutableArray* paths = [NSMutableArray array];

    for (int i=0; i < [assets count]; i++) {

        UIImage* image = photos[i];
        PHAsset* asset = assets[i];

        PHImageRequestOptions* imageRequestOptions = [[PHImageRequestOptions alloc] init];
        imageRequestOptions.synchronous = YES;

        @try {
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:imageRequestOptions
                                                        resultHandler:^(NSData *imageData, NSString *dataUTI,UIImageOrientation orientation, NSDictionary *info)
             {
                 if (info[@"PHImageFileURLKey"]) {
                     NSURL* path = info[@"PHImageFileURLKey"];
                     @try {
                         NSString* newPath = [ImageHelper localPathFromPHImageFileURL:path temp:YES];
                         [ImageHelper saveImage:image path:newPath];
//                         NSLog(@"new path %@ is created for image %i", newPath, i);
                         [paths addObject:newPath];

                     } @catch (NSException *exception) {
                         self.onFailureHandler([exception reason]);
                     }
                 }

             }

             ];
        } @catch (NSException *exception) {
            self.onFailureHandler([exception reason]);
        }

    }

    self.onCompleteHandler([self convertToJson:paths]);

}

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker{
    self.onFailureHandler(@"canceled by user");
}


@end
