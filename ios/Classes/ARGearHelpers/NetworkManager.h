#import <Foundation/Foundation.h>
#import <ARGear/ARGear.h>
#import "Models.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject

@property (nonatomic, assign) ARGSession *session;

+ (NetworkManager *)shared;

- (void)downloadItem:(ItemModel *)item
             success:(void (^)(NSString *uuid, NSURL *targetPath))successBlock
                fail:(void (^)(void))failBlock;

- (NSURL*)getCacheFile:(NSString*)fileName;
- (BOOL)isFileExist:(NSURL*)fileUrl;

@end

NS_ASSUME_NONNULL_END
