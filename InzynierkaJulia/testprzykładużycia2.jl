include("unweightedGraph.jl")
using .unweightedGraph
using LightGraphs, SimpleWeightedGraphs
using StatsBase
using DataStructures

g = read_data("out.wppt")
names = read_names("ListaImion")


#Przykład użycia dla prof. dr hab. Jacka Cichonia i dr inż. Jakuba Lemiesza
for i in 1:3
for j in collect(runrandomwalkfor2(g, 2, 15, 5, 1000, 0.85, true))[1:5]
    for k in names
        if j.first == k.first
            println(k.second," ",j.second)

        end
    end
end
println()
end
