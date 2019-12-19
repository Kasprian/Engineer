include("wpptdata.jl")
using .wpptdata
using LightGraphs, SimpleWeightedGraphs
using GraphIO
using StatsBase
using DataStructures
using FreqTables
g = read_data("powiązania")
println(runrandomwalk(g, 18, 10, 1000,0.85))
#println(b)
#runrandomwalkfor2(g, 1, 32, 9, 1000,0.85)
