//
//  NYSConfigModel.h
//  EasyRelease
//
//  Created by 倪永胜 on 2021/2/20.
//  Copyright © 2021 NYS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSConfigModel : NSObject
@property (nonatomic, strong) NSURL *projectFileDirUrl;
@property (nonatomic, strong) NSURL *projectDirUrl;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *mixArray;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *ignoreArray;
@property (nonatomic, strong) NSString *projectOldName;
@property (nonatomic, strong) NSString *projectNewName;
@property (nonatomic, assign) BOOL isDelAnnotation;
@property (nonatomic, assign) BOOL isRehashImages;
@end

NS_ASSUME_NONNULL_END
