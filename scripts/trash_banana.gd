extends Area2D

@export var trash_type: String = "banana" # Change per trash type (e.g., "paper", "bottle")

# Signal when trash is collected
signal trash_collected(trash_type)

func _ready() -> void:
	# Add to the trash group
	add_to_group("trash")

# When the player interacts with this trash, collect it
func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("player"): # Ensure it's the player
		emit_signal("trash_collected", trash_type) # Emit signal when collected
		queue_free() # Remove the trash from the map
