class_name Trainer
extends Node2D

signal generation_ended
signal next_generation_ready

@onready var bird := preload("res://Player/Bird.tscn")
# Length of the each weight in the weights array
var length := 5


# Amount of birds to spawn
var generation_size := 500

# Range of initialization for each weight
var initialization_range := [3, 300]
var default_initialization_range := 100

var weights := []

class Result:
	var score: int
	var weights: Array[float]

	func _init(_score: int, _weights: Array[float]):
		score = _score
		weights = _weights

var results : Array[Result] = []

func init() -> void:
	length = Config.selected_features.size()
	initialization_range = Config.selected_features.map(func(entry: Config.Selection): return entry.range)
	initialize_weights()


func initialize_weights() -> void:
	for i in range(generation_size):
		var weight : Array[float] = []

		for j in range(length):
			var weight_range = (initialization_range[j]
				if j < initialization_range.size()
				else default_initialization_range)

			weight.push_back(randf_range(-weight_range, weight_range))

		weights.push_back(weight)

func record_bird(score: int, weights: Array):
	var result := Result.new(score, weights)
	results.push_back(result)
	if results.size() >= generation_size:
		calculate_next_generation_weights()


func prepare_next_generation() -> void:
	# Reset the results
	results = []

	# Spawn the generation
	for weight in weights:
		var child : Bird = bird.instantiate()
		child.weights = weight
		child.died.connect(record_bird)
		add_child.call_deferred(child)

	next_generation_ready.emit()


func calculate_next_generation_weights():
	# Elitism. Keeps the top 2% best achiever.
	# Keeps at least 1 of the best.
	for i in range(1, generation_size/50 + 2):
		weights.push_back(results[-i].weights)

	while weights.size() < generation_size:
		# Selection and breeding
		var children = breed(select(), select())
		# Mutation algorithm
		for child in children:
			mutate(child)
			weights.push_back(child)

	# Clear any excess weights
	while weights.size() > generation_size: weights.pop_back()

	generation_ended.emit()

# Give back 2 different indexes with values under results.size()
# Higher score means higher chance to be selected to breed
#func roulette_select() -> Array[int]:
#	var indexes : Array[int] = []
#	for j in range(2):
#		# Randomly select a weight while letting higher scores having higher
#		# Chance of selection
#		var random_score = randi_range(0, total_scores)
#		for i in range(results.size()):
#			var result = results[i]
#			random_score -= result.score + 1
#			if random_score <= 0:
#				indexes.push_back(i)
#				break
#	# Makes sure the indexes aren't equal
#	# Makes sure the selected parents aren't the same individual
#	if indexes[0] == indexes[1]:
#		indexes[1] += 1 if (indexes[1] != results.size()-1) else -1
#	return indexes

# Tournament selection
func select() -> Array[float]:
	var tournament_size : int = generation_size * 0.02
	const selection_p = .8
	var parent : Result

	for i in range(tournament_size):
		var potential_parent = results[randi_range(0, results.size()-1)]
		if (not parent or (potential_parent.score > parent.score and randf() < selection_p)):
			parent = potential_parent

	return parent.weights


# Single point crossover
#func breed(parentA: Array[float], parentB: Array[float]) -> Array:
#	var childA = []
#	var childB = []
#	var length = min(parentA.size(), parentB.size())
#	var index = randi_range(1, length-1)
#	for i in range(length):
#		childA.push_back(parentA[i] if (i < index) else parentB[i])
#		childB.push_back(parentB[i] if (i < index) else parentA[i])
#	return [childA, childB]

# Intermediate recombination
func breed(parentA: Array[float], parentB: Array[float], child_count = 2) -> Array:
	var children = []
	var length = min(parentA.size(), parentB.size())
	var index = randi_range(1, length-1)

	# Generate 'child_count' amount of children
	for k in range(child_count):
		var child = []
		# Generate the individual weights of the child
		for i in range(length):
			var scaling_factor = randf_range(-0.25, 1.25)
			var new_gene = parentA[i]*scaling_factor + parentB[i]*(1-scaling_factor)
			child.push_back(new_gene)
		children.push_back(child)

	return children

# Mutation algorithm, modifies the weights in place
func mutate(weights: Array) -> void:
	var mutation_chance := 1/length
	const mutation_limit := 0.1

	for i in range(length):
		if randf() > mutation_chance:
			var mutation_range : float = (initialization_range[i]
				if i < initialization_range.size()
				else default_initialization_range) * mutation_limit

			weights[i] += randf_range(-mutation_range, mutation_range)
