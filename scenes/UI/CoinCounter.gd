extends HBoxContainer

## Functions
func _ready():
	# Get all the baseLevels (there is only one but it returns an array)
	var baseLevels = get_tree().get_nodes_in_group("base_level")
	
	# If we at least have one baseLevel
	if (baseLevels.size() > 0):
		# Connect to the coin_total_changed signal
		baseLevels[0].connect("coin_total_changed", self, "on_coin_total_changed")
		update_display(baseLevels[0].totalCoins, baseLevels[0].collectedCoins)
		
func update_display(totalCoins : int, collectedCoins : int):
	# Set the text of the level to display coin counter.
	$CoinLabel.text = str(collectedCoins, "/", totalCoins)
	
func on_coin_total_changed(totalCoins, collectedCoins):
	update_display(totalCoins, collectedCoins)
