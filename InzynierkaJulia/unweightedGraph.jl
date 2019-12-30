module unweightedGraph

export read_data, random_walk, runrandomwalk, runrandomwalkfor2, absorbingrandomwalk, findreviewers, read_names

using LightGraphs
using StatsBase
using DataStructures

function read_data(file_path::String)
	open(file_path) do file
		ln = split(readline(file))
		g = SimpleGraph(parse(Int64, ln[1])+8);
		while !eof(file)
			ln = split(readline(file))
			n1 = parse(Int64, ln[1])
			n2 = parse(Int64, ln[2])
			add_edge!(g, n1, n2)
		end
	return g
	end
end

function read_names(file_path::String)
	names = Pair[]
	open(file_path) do file
		while !eof(file)
			ln = split(readline(file))
			n1 = parse(Int64, ln[1])
			#n2 = parse(String, ln[2:end])
			push!(names,(n1 => string(collect(ln[2:end]))))
			#println(n1," ",ln[2:end])
		end
	end
	return names
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

function random_walk(g::SimpleGraph, start_edge::Int64, numberOfSteps::Int64, prob::Float64, tags::Bool)
	current_edge = start_edge
	NeighborsOfStart = neighbors(g,current_edge)
	for i in 1 : numberOfSteps
		if (rand() > prob)
			current_edge = start_edge
		else
			NeighborsOfVertex = neighbors(g,current_edge)
			a = rand(1:length(NeighborsOfVertex))
			current_edge = NeighborsOfVertex[a]
		end
	end
	while (current_edge == start_edge || (tags && current_edge > 28))
		NeighborsOfVertex = neighbors(g,current_edge)
		a = rand(1:length(NeighborsOfVertex))
		current_edge = NeighborsOfVertex[a]
	end

return current_edge
end

function runrandomwalk(g::SimpleGraph, start_edge::Int64, numberOfSteps::Int64, howManyTimes::Int64, prob::Float64, tags::Bool)
	x = Vector{Int64}()
	for i in 1:howManyTimes
		proposition = random_walk(g, start_edge , numberOfSteps , prob, tags)
		append!(x, proposition)
	end
	d = countmap(x)
	return OrderedDict{Int64,Float64}(sort(collect(d), by=x->x[2], rev=true))
end

function harmonic_mean(a,b)
	return 2/((1/a)+(1/b))
end

function runrandomwalkfor2(g::SimpleGraph, firstScientist::Int64, secondScientist, numberOfSteps::Int64, howManyTimes::Int64, prob::Float64, tags::Bool)
	x1=runrandomwalk(g, firstScientist, numberOfSteps, howManyTimes, prob, tags)
	x2=runrandomwalk(g, secondScientist,  numberOfSteps, howManyTimes, prob, tags)
	delete!(x1,secondScientist)
	delete!(x2,firstScientist)
	return OrderedDict(sort(collect(merge(harmonic_mean, x1, x2)), by=x->x[2], rev=true))
end

#list of scientists and reviewers
function absorbingrandomwalk(g::SimpleGraph, scientist::Int64, reviewers::Array{Int64,1}, tags::Bool)
	current_edge = scientist
	while true
		NeighborsOfVertex = neighbors(g,current_edge)
		a = rand(1:length(NeighborsOfVertex))
		current_edge = NeighborsOfVertex[a]
		if (current_edge in reviewers || (tags && current_edge > 28))
			break
		end
	end
	return current_edge
end

function findreviewers(g::SimpleGraph, scientists::Array{Int64,1}, reviewers::Array{Int64,1}, howManyTimes::Int64, tags::Bool)
	x = Vector{Int64}()
	for i in 1: howManyTimes
		proposition = absorbingrandomwalk(g, scientists[1], reviewers, tags)
		append!(x, proposition)
	end
	d = countmap(x)
	return OrderedDict(sort(collect(d), by=x->x[2], rev=true))
end

end
