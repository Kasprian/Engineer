include("algo.jl")
using .unweightedGraph
using LightGraphs, SimpleWeightedGraphs
using StatsBase
using DataStructures
using FreqTables
using TikzPictures
g = read_data("out.wppt")
#Test nr 1 pojedynczy przypadek
#println(runrandomwalk(g, 3, 20, 1000,0.85))

#neighbors(g,current_edge)

#Test nr 2, 2 osoby są autorami
#runrandomwalkfor2(g, 1, 25234, 20, 1000,0.85)

#enumerate_paths(dijkstra_shortest_paths(g, 1), 10)
#a = sample(2:317080, 50)
#println(a)
#findreviewers(g,[1],[2,7,9],100)
