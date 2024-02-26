extends Control

@onready var range = $Features/FeatureInitRange
@onready var features = $Features/FeatureList
@onready var weights = $SelectionResult/WeightsList



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Features/AddFeatureBtn.pressed.connect(add_feature)
	$SelectionResult/DeleteFeatureBtn.pressed.connect(del_feature)

func add_feature():
	if not features.is_anything_selected(): return
	if not range.text.is_valid_float(): return

	var init_range = absf(range.text.to_float())
	var index = features.get_selected_items()[0]

	Config.selected_features.push_back(
		Config.Selection.new(index, init_range)
		)

	weights.add_item(
		"%s | init range: %.2f to %.2f" %
		[features.get_item_text(index), -init_range, init_range]
		 )

func del_feature():
	if not weights.is_anything_selected(): return
	var index = weights.get_selected_items()[0]

	Config.selected_features.pop_at(index)
	weights.remove_item(index)




