include("algo.jl")
using .algo
using LightGraphs
using StatsBase
using DataStructures
using FreqTables
g = read_data("out.pajek-erdos")
#println(diameter(g))
#print(collect(edges(g)))
#Test nr 1 pojedynczy przypadek
println(runrandomwalk(g, 3, 20, 1000,0.85))

#neighbors(g,current_edge)

#Test nr 2, 2 osoby są autorami
#runrandomwalkfor2(g, 1, 25234, 20, 1000,0.85)

#enumerate_paths(dijkstra_shortest_paths(g, 1), 10)
#a = sample(2:317080, 50)
#println(a)
#findreviewers(g,[1],a,100)
