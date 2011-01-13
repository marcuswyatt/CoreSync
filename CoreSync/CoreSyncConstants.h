//
//  CoreSyncConstants.h
//  vWork
//
//  Created by Marcus Wyatt on 13/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//
//
//  URL Schemes supported
//
//    Default Resoures
//    -----------------------
//    index   GET    /jobs.json
//    show    GET    /steps/:id.json
//    create  POST   /jobs.json
//    update  PUT    /steps/:id.json
//    destroy DELETE /steps/:id.json
//
//    Shallow Nested Resoures
//    -----------------------
//    index   GET    /jobs/:job_id/steps.json
//    show    GET    /steps/:id.json
//    create  POST   /jobs/:job_id/steps.json
//    update  PUT    /steps/:id.json
//    destroy DELETE /steps/:id.json
//
//    Normal Nested Resoures
//    ----------------------
//    index   GET    /workers/:worker_id/posts.json
//    show    GET    /workers/:worker_id/posts/:id.json
//    create  POST   /workers/:worker_id/posts.json
//    update  PUT    /workers/:worker_id/posts/:id.json
//    destroy DELETE /workers/:worker_id/posts/:id.json
//
// CoreSync User Info Key Descriptions
// -----------------------------------
//
//  EntityDescription
//  -----------------
//  *  ClassNameRemote      (optional): Name of the class on the remote api (if none specified infer from the entity description name)
//  *  CollectionRoute      (optional): The resource's url route. (For example in the url http://server/jobs/1.json the CollectionRoute is 'jobs')
//  *  ResourcePathPrefix   (optional): The resource's url route prefix. (For example in the url http://server/mobile/2.0/jobs/1.json the ResourcePathPrefix is 'mobile/2.0')
//  *  ResourceTypeRemote   (Required): Specify if the url generation should take into account the ManyAssociationType value of the Relationship (if present)
//                                      when generating the urls.
//     -  NormalResource: model is standard Restful resource.
//     -  NestedResource: model has parent resource. The nested resource can be one of the ManyAssociationTypes.
//
//  AttributeDescription
//  --------------------
//  *  AttributeRemote      (Required): On all the attributes of your entities you want to sync
//  *  AttributeDateFormat  (Optional): Can specify a Date Format to use to deserialize Date and Time values
//
//
//  RelationshipDescription
//  -----------------------
//  *  ManyAssociationType  (* Required): Use in the url generation for the entity
//                                       (* When the ResourceTypeRemote has the 'NestedResource' value you have to specify the ManyAssociationType on the ToMany relationship side).
//
//     -  NormalNestedResoure                   :
//     -  ShallowNestedResoure                  : When the nesting is shallow the url only contain the parent id
//     -  BothAttributesAndNormalNestedResoure  :
//     -  BothAttributesAndShallowNestedResoure :
//
//  *  BelongToAssociation  (optional): Name of the relationship on the owning entity i.e. The BelongTo side of the relationship.
//

// (optional): Name of the class on the remote api (if none specified infer from the entity description name)
extern NSString * const kClassNameRemote;

// (optional): The resource's url route. (For example in the url http://server/jobs/1.json the CollectionRoute is 'jobs')
extern NSString * const kCollectionRoute;

// (optional): The resource's url route prefix. (For example in the url http://server/mobile/2.0/jobs/1.json the ResourcePathPrefix is 'mobile/2.0')
extern NSString * const kResourcePathPrefix;

// (Required): Specify if the url generation should take into account the ManyAssociationType value of the Relationship (if present)
extern NSString * const kResourceTypeRemote;

//  (required): On all the attributes of your entities you want to sync
extern NSString * const kAttributeRemote;

//  (optional): Can specify a Date Format to use to deserialize Date and Time values
extern NSString * const kAttributeDateFormat;

//  *  ManyAssociationType  (* Required): Use in the url generation for the entity
extern NSString * const kManyAssociationType;

//  *  BelongToAssociation  (optional): Name of the relationship on the owning entity i.e. The BelongTo side of the relationship.
extern NSString * const kBelongToAssociation;

typedef enum _Actions {
    Create = 0,
    Read = 1,
    Update = 2,
    Destroy = 3
} Actions;


typedef enum _ResourceTypeRemotes {
    NormalResource = 0,
    NestedResource = 1
} ResourceTypeRemotes;

typedef enum _ManyAssociationTypes {
    ShallowNestedResoure = 0,
    NormalNestedResoure = 1,
    BothAttributesAndShallowNestedResoure = 2,
    BothAttributesAndNormalNestedResoure = 3
} ManyAssociationTypes;
