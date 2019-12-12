include("wpptdata.jl")
using .wpptdata
using LightGraphs, SimpleWeightedGraphs
using GraphIO
using StatsBase
using DataStructures
using FreqTables
g = read_data("powiązania")
random_walk(g,1,10,0.85)
