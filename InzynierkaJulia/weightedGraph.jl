module weightedGraph

export read_data, random_walk, runrandomwalk, runrandomwalkfor2, absorbingrandomwalk, findreviewers, makestep

using LightGraphs, SimpleWeightedGraphs
using StatsBase
using DataStructures

#Function reads data from file.

function read_data(correlation_file::String)
	open(correlation_file) do file
		ln = split(readline(file))
		numberofUsers=parse(Int64, ln[1])
		g = SimpleWeightedGraph(numberofUsers+8)
		while !eof(file)
			ln = split(readline(file))
			n1 = parse(Int64, ln[1])
			n2 = parse(Int64, ln[2])
			w = parse(Int64, ln[3])
			if w == 0
				sum = 0
				for i in neighbors(g,n2)
					if i <= numberofUsers
						sum = sum + g.weights[n2, i]
					end
				end
				w = sum
				if w == 0
					w = 1
				end
			end
			add_edge!(g, n1, n2, w)
		end
		return g
	end
end

function simple_random_walk(g::SimpleWeightedGraph, start_edge::Int64, numberOfSteps::Int64)
	current_edge = start_edge
	for i in 1 : numberOfSteps
		NeighborsOfVertex = neighbors(g,current_edge)
		a = rand(1:length(NeighborsOfVertex))
		current_edge = NeighborsOfVertex[a]
	end
return current_edge
end


#Function "making one step" in graph, returns neighbor of current_edge based on probability of going to neighbors.

function makestep(g::SimpleWeightedGraph, current_edge::Int64)
	NeighborsOfVertex = neighbors(g,current_edge)
	sum = 0
	for i in NeighborsOfVertex
			sum = sum + g.weights[current_edge, i]
	end
	chance = rand()
	if chance === 0.0
	chance = 1.0
	end
	current = 0
	for i in NeighborsOfVertex
		current  = current  + g.weights[current_edge, i]
		if chance <= (current/sum)
			current_edge = i
			break
		end
	end
	return current_edge
end

#Simulation of one random walk

function random_walk(g::SimpleWeightedGraph, start_edge::Int64, numberOfSteps::Int64, prob::Float64, tags::Bool)
	current_edge = start_edge
	NeighborsOfStart = neighbors(g,current_edge)
	for i in 1 : numberOfSteps
		if (rand() > prob)
			current_edge = start_edge
		else
			current_edge = makestep(g,current_edge)
		end
	end
	while (current_edge == start_edge || (tags && current_edge > 28) )
	current_edge=makestep(g,current_edge)
	end
return current_edge
end

#Simulation of howManyTimes random walks, starting from start_edge.
#numberOfSteps - number of steps in one random walk
#prob - probability of returning to start

function runrandomwalk(g::SimpleWeightedGraph, start_edge::Int64, numberOfSteps::Int64, howManyTimes::Int64, prob::Float64, tags::Bool)
	x = Vector{Int64}()
	for i in 1:howManyTimes
		proposition = random_walk(g, start_edge , numberOfSteps , prob, tags)
		append!(x, proposition)
	end
	d = countmap(x)
	return OrderedDict{Int64,Float64}(sort(collect(d), by=x->x[2], rev=true))
end


#Returns harmonic mean of 2 numbers.

function harmonic_mean(a,b)
	return 2/((1/a)+(1/b))
end

#

function runrandomwalkfor2(g::SimpleWeightedGraph, firstScientist::Int64, secondScientist, numberOfSteps::Int64, howManyTimes::Int64, prob::Float64, tags::Bool)
	x1=runrandomwalk(g, firstScientist, numberOfSteps, howManyTimes, prob, tags)
	x2=runrandomwalk(g, secondScientist,  numberOfSteps, howManyTimes, prob, tags)
	!delete(x1,secondScientist)
	!delete(x2,firstScientist)
	return OrderedDict{Int64,Float64}(sort(collect(merge(harmonic_mean, x1, x2)), by=x->x[2], rev=true))
end



function absorbingrandomwalk(g::SimpleWeightedGraph, scientist::Int64, reviewers::Array{Int64,1})
	current_edge = scientist
	while true
		NeighborsOfVertex = neighbors(g,current_edge)
		a = rand(1:length(NeighborsOfVertex))
		current_edge = NeighborsOfVertex[a]
		if (current_edge in reviewers )
			break
		end
	end
	return current_edge
end

function findreviewers(g::SimpleWeightedGraph, scientists::Int64, reviewers::Array{Int64,1}, howManyTimes::Int64)
	x = Vector{Int64}()
	for i in 1: howManyTimes
		proposition = absorbingrandomwalk(g, scientists, reviewers)
		append!(x, proposition)
	end
	d = countmap(x)
	return OrderedDict(sort(collect(d), by=x->x[2], rev=true))
end

end
