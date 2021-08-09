oc new-app --name=fatfish-sample-app https://github.com/Terrafire123/sample-python.git --strategy="docker" -o yaml >samplebuildconfig.yaml



1. Create a dockerhub account.
2. Create a new private repository, called "sample-python-repo".
# When building the docker image, give it a name {Username}/{RepoName}:{tag}
3. sudo docker build -t eliezerberlin/sample-python-repo:latest .
4. sudo docker login
5. sudo docker push eliezerberlin/sample-python-repo:latest

6. Go to https://console.pro-us-east-1.openshift.com/console/project/fatfish-test/overview
7. Press "Add to Project -> Deploy Image"
7a. Image name: "eliezerberlin/sample-python-repo:latest"
7b. Press the "Magnifying glass" button next to image name, to verify OpenShift can read the image correctly.
7c. Press "Deploy"
8. Create route so it can be accessed from outside.
8a. "Create Route" button.
8b. Target Port "8080"
8c. "Secure Route" : TRUE
