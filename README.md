Notes:
We changed a few lines in requirements.txt:
1.
pandas==1.2.0 to pandas==1.1.5
(Pandas 1.1.5 is the latest available version in Openshift's PIP repository.)

2.
Removed pkg-resources==0.0.0
This appears as a bug, as per https://stackoverflow.com/questions/39577984/what-is-pkg-resources-0-0-0-in-output-of-pip-freeze-command

3.
pyproj==3.0.0.post1 requires us to update PIP to version >=10.0.1 as per https://github.com/pyproj4/pyproj/issues/177
so we update pip via the environment variable 
UPGRADE_PIP_TO_LATEST = true
set in the Edit Application ( https://console.pro-us-east-1.openshift.com/console/project/fatfish-test/edit/dc/test-python-server )

4.
Rtree==0.9.4 to Rtree>=0.9.4 
(Rtree 0.9.7 resolves correctly, 0.9.4 fails to compile.)

This is a known issue:
https://github.com/Toblerity/rtree/issues/64
sudo apt install libspatialindex-dev python3-rtree

5. 
Renamed starting python file to app.py

