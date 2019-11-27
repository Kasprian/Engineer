include("algo.jl")
using .algo
using LightGraphs
using StatsBase
using DataStructures
using FreqTables
g = read_data("out.com-dblp")
#print(collect(edges(g)))
#print(random_walk(g,1,5,0.5))

#d = countmap(runrandomwalk(g, 1, 20, 1000,0.85))
#println(OrderedDict(sort(collect(d), by=x->x[2], rev=true)))

#enumerate_paths(dijkstra_shortest_paths(g, 1), 10)
a = sample(2:317080, 50)
println(a)
findreviewers(g,[1],a,100)
