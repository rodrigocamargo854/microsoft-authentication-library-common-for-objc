// Copyright (c) Microsoft Corporation.
// All rights reserved.
//
// This code is licensed under the MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MSIDLogger.h"
#import "MSIDLogger+Internal.h"
#import "MSIDVersion.h"
#import "MSIDDeviceId.h"
#import <pthread.h>

@interface MSIDLogger()
{
    MSIDLogCallback _callback;
}

@property (nonatomic) dispatch_queue_t loggerQueue;

@end

@implementation MSIDLogger

- (id)init
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    // The default log level should be info, anything more restrictive then this
    // and we'll probably not have enough diagnostic information, however verbose
    // will most likely be too noisy for most usage.
    _level = MSIDLogLevelInfo;
    _PiiLoggingEnabled = NO;
    
    NSString *queueName = [NSString stringWithFormat:@"com.microsoft.msidlogger-%@", [NSUUID UUID].UUIDString];
    _loggerQueue = dispatch_queue_create([queueName cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_SERIAL);
    
    return self;
}

+ (MSIDLogger *)sharedLogger
{
    static dispatch_once_t once;
    static MSIDLogger *s_logger;
    
    dispatch_once(&once, ^{
        s_logger = [MSIDLogger new];
    });
    
    return s_logger;
}

- (void)setCallback:(MSIDLogCallback)callback
{
    if (_callback != nil)
    {
        @throw @"MSID logging callback can only be set once per process and should never changed once set.";
    }
 
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        self->_callback = callback;
    });
}

@end

@implementation MSIDLogger (Internal)

static NSDateFormatter *s_dateFormatter = nil;

+ (void)initialize
{
    s_dateFormatter = [[NSDateFormatter alloc] init];
    [s_dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [s_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (void)logLevel:(MSIDLogLevel)level
         context:(id<MSIDRequestContext>)context
   correlationId:(NSUUID *)correlationId
           isPII:(BOOL)isPii
          format:(NSString *)format, ...
{
    if (!format) return;
    if (isPii && !self.PiiLoggingEnabled) return;
    if (level > self.level) return;
    if (!_callback && !_NSLoggingEnabled) return;
    
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    __uint64_t tid;
    pthread_threadid_np(NULL, &tid);
    
    dispatch_async(self.loggerQueue, ^{
        NSString *logComponent = [context logComponent];
        NSString *componentStr = logComponent ? [NSString stringWithFormat:@" [%@]", logComponent] : @"";
        
        NSString *correlationIdStr = @"";
        
        if (correlationId)
        {
            correlationIdStr = [NSString stringWithFormat:@" - %@", correlationId.UUIDString];
        }
        else if (context)
        {
            correlationIdStr = [NSString stringWithFormat:@" - %@", [context correlationId]];
        }
        
        NSString *dateStr = [s_dateFormatter stringFromDate:[NSDate date]];
        
        NSString *sdkName = [MSIDVersion sdkName];
        NSString *sdkVersion = [MSIDVersion sdkVersion];
        
        __auto_type threadName = [[NSThread currentThread] isMainThread] ? @" (main thread)" : nil;
        if (!threadName) {
            threadName = [NSThread currentThread].name ?: @"";
        }

        __auto_type threadInfo = [[NSString alloc] initWithFormat:@"TID = %llu%@", tid, threadName];
        
        if (self.NSLoggingEnabled)
        {
            NSString *levelStr = [self stringForLogLevel:_level];
            
            NSString *log = [NSString stringWithFormat:@"%@ %@ %@ %@ [%@%@]%@ %@: %@", threadInfo, sdkName, sdkVersion, [MSIDDeviceId deviceOSId], dateStr, correlationIdStr, componentStr, levelStr, message];
            
            NSLog(@"%@", log);
        }
        
        if (_callback)
        {
            NSString *log = [NSString stringWithFormat:@"%@ %@ %@ %@ [%@%@]%@ %@", threadInfo, sdkName, sdkVersion, [MSIDDeviceId deviceOSId], dateStr, correlationIdStr, componentStr, message];
            
            _callback(level, log, isPii);
        }
    });
}

- (NSString*)stringForLogLevel:(MSIDLogLevel)level
{
    switch (level)
    {
        case MSIDLogLevelNothing: return @"NONE";
        case MSIDLogLevelError: return @"ERROR";
        case MSIDLogLevelWarning: return @"WARNING";
        case MSIDLogLevelInfo: return @"INFO";
        case MSIDLogLevelVerbose: return @"VERBOSE";
    }
}

- (void)logToken:(NSString *)token
       tokenType:(NSString *)tokenType
   expiresOnDate:(NSDate *)expiresOn
    additionaLog:(NSString *)additionalLog
         context:(id<MSIDRequestContext>)context
{
    NSMutableString *logString = nil;
    
    if (context)
    {
        [logString appendFormat:@"%@ ", additionalLog];
    }
    
    [logString appendFormat:@"%@ (%@)", tokenType, [token msidTokenHash]];
    
    if (expiresOn)
    {
        [logString appendFormat:@" expires on %@", expiresOn];
    }
    
    MSID_LOG_INFO_PII(context, @"%@", logString);
}

@end
