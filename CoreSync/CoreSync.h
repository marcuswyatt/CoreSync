/*
 Copyright (C) 2009-2011 Marcus Wyatt. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

 * Neither the name of the author nor the names of its contributors may be used
   to endorse or promote products derived from this software without specific
   prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 @mainpage
 The CoreSync Framework's goal is to provide a mechanism of synchronizing CoreData
 with an Restful JSON API backend with a minimal impact. No need to subclass or
 import categories. You just need to define your entities and relationships for
 your domain model using the data model and then define some additional user info
 keys and values. Setup the CoreSyncManager with a remote url and Voila!

 Our Core Data entities sync's with your Restful API backend.

 @section Links

 @li <a href="http://www.coresync.com">CoreSync Home Page</a>.
 @li <a href="https://github.com/marcuswyatt/CoreSync">Source Code</a>.
 @li <a href="http://www.coresync.com/api">API documentation</a>.

 @section Features

 @li Very productive to work with
 @li Easy install and setup
 @li No custom coding to use. Only specifying a few User Info keys and we are off
     to the races.
*/


// This setting of 1 is best if you copy the source into your project.
// The build transforms the 1 to a 0 when building the framework and static lib.

#if 1

#import "CoreSyncConstants.h"
#import "CoreSyncManager.h"
#import "CoreSyncModelMapper.h"
#import "CoreSyncUrlGenerator.h"

#import "ThreadedCoreDataOperation.h"
#import "CoreDataModelSyncOperation.h"
#import "CoreDataModelDestroyOperation.h"
#import "CoreDataModelUpdateOperation.h"

#import "ThreadedCoreDataOperationDelegate.h"

#import "CoreSyncUtils.h"

#import "NSString+InflectionSupport.h"

#else

#import <CoreSync/CoreSyncConstants.h>
#import <CoreSync/CoreSyncManager.h>
#import <CoreSync/CoreSyncModelMapper.h>
#import <CoreSync/CoreSyncUrlGenerator.h>

#import <CoreSync/ThreadedCoreDataOperation.h>
#import <CoreSync/CoreDataModelSyncOperation.h>
#import <CoreSync/CoreDataModelDestroyOperation.h>
#import <CoreSync/CoreDataModelUpdateOperation.h>

#import <CoreSync/ThreadedCoreDataOperationDelegate.h>

#import <CoreSync/CoreSyncUtils.h>

#import <CoreSync/NSString+InflectionSupport.h>

#endif
