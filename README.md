# sample-python

Dockerfile pulled from Openshift's official python docker
https://github.com/sclorg/s2i-python-container/tree/master/3.6

Notes:

Changed

pandas==1.2.0 to panda==1.1.5


Removed pkg-resources==0.0.0 as per https://stackoverflow.com/questions/39577984/what-is-pkg-resources-0-0-0-in-output-of-pip-freeze-command


As per https://github.com/pyproj4/pyproj/issues/177
Update pip to >=10.0.1 or downgrade package to 1.9.6
pyproj==3.0.0.post1 to pyproj==1.9.6


rtree
https://github.com/Toblerity/rtree/issues/64
sudo apt install libspatialindex-dev python-rtree
use python3-rtree instead.

Removed entirely, temporarily.
