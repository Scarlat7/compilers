#!/usr/bin/python3
import os.path
import sys
import pandas
from zss import distance, simple_distance, Node

def read_csv_to_tree (filename):
    # Read the CSV using pandas
    df = pandas.read_csv(filename, header=None, names=["Pai", "Filho"], skipinitialspace = True)
    if len(df.index) == 0:
        return None

    # Create a set with all the nodes
    N = set()
    N.update(df.Pai.values)
    N.update(df.Filho.values)

    # define the name of the root node (the first one)
    ROOTstr = df.Pai.values[0]

    # Create all nodes and add them to a dictionary called "nodes"
    nodes = {}
    for node in N:
        if node in nodes.keys():
           a = nodes[node]
        else:
           a = Node("")
           nodes[node] = a

    # Add all edges
    for index, row in df.iterrows():
      paistr = row['Pai']
      filhostr = row['Filho']
      if index is 0:
          print("n", paistr, " [label=\"root\"];", sep="")
      try:
          pai = nodes[paistr]
          filho = nodes[filhostr]
          print("n", paistr, " -> n", filhostr, ";", sep="")
          pai.addkid(filho)
      except:
          pass

    # Get root node and return
    ROOT = nodes[ROOTstr]
    return ROOT

if len(sys.argv) != 2:
    print ("One CSV filename must be provided.")
    sys.exit(255)
if os.path.isfile(sys.argv[1]) is False:
    print ("File "+sys.argv[1]+" does not exist.")
    sys.exit(254)

print("digraph G {")
A = read_csv_to_tree (sys.argv[1])
print("}")

sys.exit(0)