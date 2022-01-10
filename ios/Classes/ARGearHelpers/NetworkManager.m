#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import "Models.h"

@implementation NetworkManager

+ (NetworkManager *)shared {
    static dispatch_once_t pred;
    static NetworkManager *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[NetworkManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)downloadItem:(ItemModel *)item
             success:(void (^)(NSString *uuid, NSURL *targetPath))successBlock
                fail:(void (^)(void))failBlock {
    
    NSString *uuid = [item uuid];
    NSString *fileUrl = [item zip_file];
    NSString *type = [item type];
    NSString *title = [item title];
    
    ARGAuthCallback callback = ^(NSString *url, ARGStatusCode code) {
        if (code == ARGStatusCode_SUCCESS) {
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

            NSURL *URL = [NSURL URLWithString:url];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];

            NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                NSURL *cacheDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory
                    inDomain:NSUserDomainMask
                    appropriateForURL:nil
                    create:NO
                    error:nil];

                return [cacheDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {

                if (error) {
                    failBlock();
                    return;
                }

                successBlock(uuid, filePath);
            }];

            [downloadTask resume];
        } else {
            [self alertByCode:code];
            failBlock();
        }
    };

    [[_session auth] requestSignedUrlWithUrl:fileUrl itemTitle:title itemType:type completion:callback];

}

- (NSURL*)getCacheFile:(NSString*)fileName {
    NSURL *cacheDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory
        inDomain:NSUserDomainMask
        appropriateForURL:nil
        create:NO
        error:nil];

    NSString* fullName = [NSString stringWithFormat:@"%@.zip", fileName];
    return [cacheDirectoryURL URLByAppendingPathComponent:fullName];
}

- (BOOL)isFileExist:(NSURL*)fileUrl {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileUrl.absoluteString]) {
        return true;
    } else {
        return false;
    }
}

- (void)alertByCode:(ARGStatusCode)code {
    
    NSString *errorTitle = @"";
    NSString *errorMessage = @"";
    
    switch (code) {
        case ARGStatusCode_NETWORK_OFFLINE:
            errorTitle = @"Network offline";
            break;
        case ARGStatusCode_NETWORK_TIMEOUT:
            errorTitle = @"Network timeout";
            break;
        case ARGStatusCode_NETWORK_ERROR:
            errorTitle = @"Network error";
            break;
        case ARGStatusCode_INVALID_AUTH:
            errorTitle = @"Invalid auth";
            break;
        default:
            break;
    }
    errorMessage = [NSString stringWithFormat:@"error code %ld", (long)code];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:errorTitle message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:okAction];

    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
}

@end
