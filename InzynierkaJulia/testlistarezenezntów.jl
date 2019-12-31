include("unweightedGraph.jl")
using .unweightedGraph
using LightGraphs, SimpleWeightedGraphs
using StatsBase
using DataStructures

g = read_data("out.wppt")
names = read_names("ListaImion")

for j in findreviewers(g, 18, [1,10,11,13,14,24,25], 1000)
    for k in names
        if j.first == k.first
            println(k.second," ",j.second)
        end
    end
end
