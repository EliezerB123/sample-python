1. Create a dockerhub account.
2. Create a new public repository, called "sample-python-repo".

     

3. sudo docker build -t eliezerberlin/sample-python-repo:latest .

    3a. (When building the docker image, give it a name {Username}/{RepoName}:{tag})
4. sudo docker login
5. sudo docker push eliezerberlin/sample-python-repo:latest

6. Go to https://console.pro-us-east-1.openshift.com/console/project/fatfish-test/overview
7. Press "Add to Project -> Deploy Image"

    7a. Image name: "eliezerberlin/sample-python-repo:latest"

    7b. Press the "Magnifying glass" button next to image name, to verify OpenShift can read the image correctly.

    7c. Press "Deploy"

8. Create route so it can be accessed from outside.

    8a. "Create Route" button.

    8b. Target Port "8080" -> "8080" (That means outer port 8080 should be forwarded to inner port 8080)

    8c. "Secure Route" : TRUE

9. Set Enviroment variables

    9a. Go to Resources -> Secrets

    9b. Press "Create Secret"

    9c. 
        "Secret Type": Generic Secret
        "Secret Name": "my-python-git-credentials"

    9d. Add three keys. After each key, press "Add Item" to add another.

        Key: GIT_USERNAME
        Value: (The GIT username)

        Key: GIT_PASS
        Value: (The GIT password. Note that if the password has any special characters, they need to be escaped, as per https://en.wikipedia.org/wiki/Percent-encoding#Reserved_characters. For example, "MyP@ssword" would turn into "MyP%40ssword", since we remove the "@". )

        Key: GIT_URL
        Value: (HTTPS GIT URL. For example, "bitbucket.org/urban_dash/urban-utils.git" )

    9e. Save.

    9f. Go to Applications->Deployments (https://console.pro-us-east-1.openshift.com/console/project/fatfish-test/browse/deployments)

    9g. Press "Environment"

    9h. Under "Enviroment From", choose "my-python-git-credentials". (From Step 9c)

    9i. Press "Save".

10. Create Persistent File Storage.

    10a. Go to "Storage" (https://console.pro-us-east-1.openshift.com/console/project/fatfish-test/browse/storage)

    10b. Press "Create Storage".

    10c.  (More info: https://docs.openshift.com/online/pro/architecture/additional_concepts/storage.html#pv-access-modes)
        "Storage Class" : (Whatever you like)
        "Name" : My-Python-Disk
        "Size" : 1GB
    
    10d. Press "Create".
    
11. Attach our new storage to our Instance. (This will cause the instance to reload automatically with the new storage.)
    
    11a. Go to Applications->Deployments (https://console.pro-us-east-1.openshift.com/console/project/fatfish-test/browse/deployments)

    11b. Choose existing image.

    11c. Choose "Configuration" tab. 

    11d. Press "Add Storage".

    11e. 
        "Storage" : My-Python-Disk
        "Mount Path" : /data
    
    11f. Press "Add".



--------

The way the Persistent Filesystem works is as follows:
Anything located inside the directory "/data" (As defined in step 11e) will persist when the server is restarted.

