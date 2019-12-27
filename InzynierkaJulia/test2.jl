include("weightedGraph.jl")
using .weightedGraph
using LightGraphs, SimpleWeightedGraphs
using GraphIO
using StatsBase
using DataStructures
using FreqTables
using GraphPlot, Compose
g = read_data("out.wppt")
#println(runrandomwalk(g, 2, 10, 1000,0.85))
#println(b)
#runrandomwalkfor2(g, 1, 28, 9, 1000,0.85)

findreviewers(g,[1],[2,7,9,13],1000)
