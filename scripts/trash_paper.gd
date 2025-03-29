extends Area2D

signal trash_collected(trash_type)

@export var trash_type: String = "paper" # Change per trash type (e.g., "paper", "bottle")

func _ready():
	# Add to the trash group
	add_to_group("trash")
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): # Ensure it's the player
		emit_signal("trash_collected", trash_type) # Emit signal when collected
		queue_free() # Remove the trash from the map
