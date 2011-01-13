# CoreSync Framework

The CoreSync Framework's goal is to provide a mechanism of synchronizing CoreData with an Restful JSON API backend with a minimal impact. No need to subclass or import categories. You just need to define your entities and relationships for your domain model using the data model and then define some additional user info keys and values. Setup the CoreSyncManager with a remote url and Voila! Our Core Data entities sync's with your Restful API backend.

-----------------------------------
 
## Features

*   Very productive to work with
*   Easy install and setup
*   No custom coding to use. Only specifying a few User Info keys and we are off
    to the races.

-----------------------------------

## Wiki

*   [Introduction](https://github.com/marcuswyatt/CoreSync/wiki/Introduction "Introduction")
*   [How it works?](https://github.com/marcuswyatt/CoreSync/wiki/How_it_works "How it works?")
*   [Installation](https://github.com/marcuswyatt/CoreSync/wiki/Installation "Installation")
*   [Setup](https://github.com/marcuswyatt/CoreSync/wiki/Setup "Setup")
*   [Tutorial](https://github.com/marcuswyatt/CoreSync/wiki/Installation "Tutorial")
*   [Discussion Group](https://github.com/marcuswyatt/CoreSync/wiki/Installation "Discussion Group")
*   [FAQ](https://github.com/marcuswyatt/CoreSync/wiki/FAQ "FAQ")
*   [Bug Reports](https://github.com/marcuswyatt/CoreSync/wiki/FAQ "Bug Reports")

-----------------------------------
     
### Supported URL Schemes 

#### Default Resoures

    index   GET    /jobs.json
    show    GET    /steps/:id.json
    create  POST   /jobs.json
    update  PUT    /steps/:id.json
    destroy DELETE /steps/:id.json

#### Shallow Nested Resoures

    index   GET    /jobs/:job_id/steps.json
    show    GET    /steps/:id.json
    create  POST   /jobs/:job_id/steps.json
    update  PUT    /steps/:id.json
    destroy DELETE /steps/:id.json

#### Normal Nested Resoures

    index   GET    /workers/:worker_id/posts.json
    show    GET    /workers/:worker_id/posts/:id.json
    create  POST   /workers/:worker_id/posts.json
    update  PUT    /workers/:worker_id/posts/:id.json
    destroy DELETE /workers/:worker_id/posts/:id.json

 -----------------------------------
 
### CoreSync Mapping Variables

The following mapping variables are used by CoreSync to annotate the entities with additional metadata needed for syncing.

### EntityDescription

*   **ClassNameRemote** (optional)
    Name of the class on the remote api (if none specified infer from the entity description name)
    
*   **CollectionRoute** (optional)
    The resource's url route. (For example in the url http://server/jobs/1.json the CollectionRoute is 'jobs')
    
*   **ResourcePathPrefix** (optional)  
    The resource's url route prefix. (For example in the url http://server/mobile/2.0/jobs/1.json the ResourcePathPrefix is 'mobile/2.0')
    
*   **ResourceTypeRemote** (required) 
    Specify if the url generation should take into account the ManyAssociationType value of the Relationship (if present) when generating the urls.
    
     -  **NormalResource**
        Model is standard Restful resource.
     -  **NestedResource**
        Model has parent resource. The nested resource can be one of the ManyAssociationTypes.

### AttributeDescription

*   **AttributeRemote** (required)      
    On all the attributes of your entities you want to sync
    
*   **AttributeDateFormat** (optional)    
    Can specify a Date Format to use to deserialize Date and Time values

### RelationshipDescription

*   **ManyAssociationType** (required)
    Use in the url generation for the entity (When the *ResourceTypeRemote* has the *'NestedResource'* value you have to specify the ManyAssociationType on the ToMany relationship side).

     -  **NormalNestedResoure**                   
     
     -  **ShallowNestedResoure**                  
     When the nesting is shallow the url only contain the parent id
     
     -  **BothAttributesAndNormalNestedResoure**
     
     -  **BothAttributesAndShallowNestedResoure** :

*   **BelongToAssociation**  (optional)
    Name of the relationship on the owning entity i.e. The BelongTo side of the relationship.

-----------------------------------

## Required Dependencies

*   [json-framework](https://github.com/stig/json-framework "json-framework")
*   [ASIHTTPRequest](https://github.com/pokeb/asi-http-request "ASIHTTPRequest")
    
-----------------------------------        

## Links

*   [CoreSync Home Page](http://www.coresync.com "CoreSync Home Page")
*   [Github Source Repository](http://www.coresync.com "Source Code")
*   [API documentation](http://www.coresync.com/api "API documentation")