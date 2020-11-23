//
//  LogConst.h
//  iOSMain
//
//  Created by shenjie on 2020/11/23.
//

#ifndef LogConst_h
#define LogConst_h

#ifndef LogError

#import <CocoaLumberjack/CocoaLumberjack.h>

#ifdef DEBUG
static const int ddLogLevel = DDLogLevelVerbose;
#else
static const int ddLogLevel = DDLogLevelOff;
#endif

#define LogError(format, ...)                                                                                   \
{                                                                                                                 \
   DDLogError((@"%@.m:%d Error:" format), NSStringFromClass([self class]), __LINE__, ## __VA_ARGS__);               \
}

#endif

#ifndef LogWarn
#define LogWarn(format, ...)                                                                                   \
{                                                                                                                \
    DDLogWarn((@"%@.m:%d Warn:" format), NSStringFromClass([self class]), __LINE__, ## __VA_ARGS__);             \
}

#endif

#ifndef LogInfo
#define LogInfo(format, ...)                                                                                   \
{                                                                                                                \
    DDLogInfo((@"%@.m:%d Info:" format), NSStringFromClass([self class]), __LINE__, ## __VA_ARGS__);             \
}

#endif

#ifndef LogDebug
#define LogDebug(format, ...)                                                                                   \
{                                                                                                                 \
    DDLogDebug((@"%@.m:%d Debug:" format), NSStringFromClass([self class]), __LINE__, ## __VA_ARGS__);            \
}

#endif

#ifndef LogVerbose
#define LogVerbose(format, ...)                                                                               \
{                                                                                                               \
    DDLogVerbose((@"%@.m:%d Verbose:" format), NSStringFromClass([self class]), __LINE__, ## __VA_ARGS__);      \
}

#endif

#endif /* LogConst_h */
