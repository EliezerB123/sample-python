

import numpy as np
import pandas as pd

from shapely.geometry import Point,Polygon,LineString
from shapely.ops import transform
from shapely.strtree import STRtree

from pymongo import MongoClient

import geopandas as gpd
from pyproj import Proj, CRS, Transformer

import osmnx as ox
import networkx as nx


#Import SimpleHTTPServer modules
import http.server
import socketserver
import sys


print('done')


PORT = 8080

handler = http.server.SimpleHTTPRequestHandler

with socketserver.TCPServer(("", PORT), handler) as httpd:
    print("Server started at localhost:" + str(PORT))
    httpd.serve_forever()