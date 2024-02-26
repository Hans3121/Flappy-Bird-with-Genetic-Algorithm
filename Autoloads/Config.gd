extends Node

# Default features. Should be the same with feature_selection.tscn
var selected_features : Array[Selection] = [
	Selection.new(0, 300),
	Selection.new(1, 1),
	Selection.new(2, 1)
]
class Selection:
	var type: int
	var range: float

	func _init(_type: int, _range: float):
		type = _type
		range = _range
