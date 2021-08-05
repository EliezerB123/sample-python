

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

print('done')

def run(server_class=HTTPServer, handler_class=BaseHTTPRequestHandler):
    server_address = ('', 8080)
    httpd = server_class(server_address, handler_class)
    httpd.serve_forever()


run()
