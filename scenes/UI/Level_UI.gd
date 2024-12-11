extends CanvasLayer

func _ready():
	# Get all the baseLevels (there is only one but it returns an array)
	var baseLevels = get_tree().get_nodes_in_group("base_level")
	
	# If we at least have one baseLevel
	if (baseLevels.size() > 0):
		# Connect to the coin_total_changed signal
		baseLevels[0].connect("coin_total_changed", self, "on_coin_total_changed")
		

func on_coin_total_changed(totalCoins, collectedCoins):
	# Set the text of the level to display coin counter.
	$MarginContainer/HBoxContainer/CoinLabel.text = str(collectedCoins, " / ", totalCoins)
	
