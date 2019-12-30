include("unweightedGraph.jl")
using .unweightedGraph
using LightGraphs, SimpleWeightedGraphs
using StatsBase
using DataStructures

g = read_data("out.wppt")
#Test współczynniku tłumienia dla jednego autora
println("start")
for k in 1:10
   len = 0
   for a in 1:28
      for y in 1:10
         x = Array{Int64,1}()
         for i in 1:100
            append!(x, map(x -> x[1],collect(runrandomwalk(g, a, 10, 1000, 0.05+0.1*(k-1), true))[1:5]))
         end
         m = collect(keys(countmap(x)))
         size = count(r->(r>0), m)
         #println(count(i->(i>0), m))
         len=len+size
      end
   end
   println("Prob ",0.05+0.1*(k-1)," ", len/280 )
end
