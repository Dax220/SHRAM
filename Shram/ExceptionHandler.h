#import <Foundation/Foundation.h>

NS_INLINE NSException * _Nullable tryBlock(void(^_Nonnull tryBlock)(void)) {
    @try {
        tryBlock();
    }
    @catch (NSException *exception) {
        NSLog(@"Shram Exeption = %@", exception);
        return exception;
    }
    return nil;
}

