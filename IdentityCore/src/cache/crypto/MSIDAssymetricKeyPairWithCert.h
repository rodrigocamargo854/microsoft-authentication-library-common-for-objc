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

#import "MSIDAssymetricKeyPair.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSIDAssymetricKeyPairWithCert : MSIDAssymetricKeyPair
{
    SecCertificateRef _certificateRef;
    NSData *_certificateData;
    NSString *_certificateSubject;
    NSString *_certificateIssuer;
}

@property (nonatomic, readonly) SecCertificateRef certificateRef;
@property (nonatomic, readonly) NSData *certificateData;
@property (nonatomic, readonly) NSString *certificateSubject;
@property (nonatomic, readonly) NSString *certificateIssuer;

- (nullable instancetype)initWithPrivateKey:(SecKeyRef)privateKey
                                  publicKey:(SecKeyRef)publicKey
                                certificate:(SecCertificateRef)certificate
                          certificateIssuer:(NSString *)issuer
                               creationDate:(nullable NSDate *)creationDate;

- (nullable instancetype)initWithPrivateKey:(SecKeyRef)privateKey
                                  publicKey:(SecKeyRef)publicKey
                               creationDate:(nullable NSDate *)creationDate NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
