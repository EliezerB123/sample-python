# sample-python

Dockerfile pulled from Openshift's official python docker
https://github.com/sclorg/s2i-python-container/tree/master/3.6

Notes:

Changed
1.
pandas==1.2.0 to panda==1.1.5
(Pandas 1.1.5 is the latest available version in Openshift's repository.)

2.
Removed pkg-resources==0.0.0 as per https://stackoverflow.com/questions/39577984/what-is-pkg-resources-0-0-0-in-output-of-pip-freeze-command

3.
pyproj==3.0.0.post1 works, but it requires us to update PIP pip to version >=10.0.1 as per 
As per https://github.com/pyproj4/pyproj/issues/177
so we update pip via the environment variable 
UPGRADE_PIP_TO_LATEST = true
set in the Edit Application ( https://console.pro-us-east-1.openshift.com/console/project/fatfish-test/edit/dc/test-python-server )

4.
rtree
Rtree==0.9.4 to Rtree>=0.9.4 (Rtree 0.9.7 resolves correctly, 0.9.4 fails to compile.)

This is a known issue:
https://github.com/Toblerity/rtree/issues/64
sudo apt install libspatialindex-dev python3-rtree

