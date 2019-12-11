module algo

export read_data, random_walk, runrandomwalk, runrandomwalkfor2, absorbingrandomwalk, findreviewers

using LightGraphs
using StatsBase
using DataStructures

function read_data(file_path::String)
	open(file_path) do file
		ln = split(readline(file))
		g = SimpleGraph(parse(Int64, ln[1]));
		while !eof(file)
			ln = split(readline(file))
			n1 = parse(Int64, ln[1])
			n2 = parse(Int64, ln[2])
			add_edge!(g, n1, n2)
		end
	return g
	end
end


function simple_random_walk(g::SimpleGraph, start_edge::Int64, numberOfSteps::Int64)
	current_edge = start_edge
	for i in 1 : numberOfSteps
		NeighborsOfVertex = neighbors(g,current_edge)
		a = rand(1:length(NeighborsOfVertex))
		current_edge = NeighborsOfVertex[a]
	end
return current_edge
end

function random_walk(g::SimpleGraph, start_edge::Int64, numberOfSteps::Int64, prob::Float64)
	current_edge = start_edge
	NeighborsOfStart = neighbors(g,current_edge)
	for i in 1 : numberOfSteps
		if (rand() > prob)
			current_edge = start_edge
		else
			NeighborsOfVertex = neighbors(g,current_edge)
			a = rand(1:length(NeighborsOfVertex))
			current_edge = NeighborsOfVertex[a]
			if !(current_edge in NeighborsOfStart)  && current_edge !=start_edge
				break
			end
		end
		if (current_edge == start_edge || current_edge in NeighborsOfStart)
			while true
				NeighborsOfVertex = neighbors(g,current_edge)
				a = rand(1:length(NeighborsOfVertex))
				current_edge = NeighborsOfVertex[a]
				if !(current_edge in NeighborsOfStart) && current_edge !=start_edge
					break
				end
			end
		end
	end
return current_edge
end

function runrandomwalk(g::SimpleGraph,start_edge::Int64, numberOfSteps::Int64,howManyTimes::Int64,prob::Float64)
	x = Vector{Int64}()
	for i in 1:howManyTimes
		proposition = random_walk(g, start_edge , numberOfSteps , prob)
		append!(x, proposition)
		#println(proposition)
		#enumerate_paths(dijkstra_shortest_paths(g, 1), proposition)
		#println()
	end
	d = countmap(x)
	return OrderedDict(sort(collect(d), by=x->x[2], rev=true))
end

function runrandomwalkfor2(g::SimpleGraph, firstScientist::Int64, secondScientist, numberOfSteps::Int64, howManyTimes::Int64, prob::Float64)
	x1=runrandomwalk(g, firstScientist, 20, 1000,0.85)
	x2=runrandomwalk(g, secondScientist, 20, 1000,0.85)
	ranking = Vector{Int64}()
	println(collect(x1)[1:20])
	println()
	println(collect(x2)[1:20])
	println()
	println()
	println()
	for d in collect(x1)[1:100]
		lengthto1 = length(enumerate_paths(dijkstra_shortest_paths(g, firstScientist), d.first))
		lengthto2 = length(enumerate_paths(dijkstra_shortest_paths(g, secondScientist),  d.first))
		println(d," ",lengthto1+lengthto2)
	end
	for d in collect(x2)[1:100]
		lengthto1 = length(enumerate_paths(dijkstra_shortest_paths(g, firstScientist),  d.first))
		lengthto2 = length(enumerate_paths(dijkstra_shortest_paths(g, secondScientist),  d.first))
		println(d," ",lengthto1+lengthto2)
	end
	println()
	println()
	println(ranking)
end

#list of scientists and reviewers
function absorbingrandomwalk(g::SimpleGraph,scientist::Int64,reviewers::Array{Int64,1})
	current_edge = scientist
	while true
		NeighborsOfVertex = neighbors(g,current_edge)
		a = rand(1:length(NeighborsOfVertex))
		current_edge = NeighborsOfVertex[a]
		if current_edge in reviewers
			break
		end
	end
	return current_edge
end

function findreviewers(g::SimpleGraph,scientists::Array{Int64,1},reviewers::Array{Int64,1},howManyTimes::Int64)
	x = Vector{Int64}()
	for i in 1: howManyTimes
		proposition = absorbingrandomwalk(g, scientists[1], reviewers)
		append!(x, proposition)
	end
	d = countmap(x)
	println(OrderedDict(sort(collect(d), by=x->x[2], rev=true)))

end

end
