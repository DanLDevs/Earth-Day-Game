extends CharacterBody2D

const SPEED = 130.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var interaction_area = $Area2D
@onready var player = get_node("Player")  # Replace with the actual player node name

var last_direction = "idle_down"  # Default idle direction

# When the player enters an area (trash or bin area)
func _on_body_entered(body):
	print("Body entered: ", body.name)  # Debug print
	if body.is_in_group("trash"):  # Check if body is part of the trash group
		print("Player collides with trash: ", body.name)  # Debug print
		body.queue_free()  # Remove the trash item from the scene (collect it)
	elif body.is_in_group("bin"):  # Check if body is part of the bin group
		print("Player near bin: ", body.name)  # Debug print

# When the player exits an area (trash or bin area)
func _on_body_exited(body):
	print("Body exited: ", body.name)  # Debug print
	if body == player:  # Ensure it's the player exiting
		print("Player exited the area")

func _ready() -> void:
	print("Inventory system initialized!")  # Debug print to confirm everything is set up
	add_to_group("player")  # Add the player to the "player" group

	# Ensure the player is inside the interaction area when game starts
	var overlapping_bodies = interaction_area.get_overlapping_bodies()
	if overlapping_bodies.size() > 0:
		for body in overlapping_bodies:
			if body == player:
				print("Player is in the interaction area")
			else:
				print("Something else is in the interaction area")
	else:
		print("No overlapping bodies at start")

func _physics_process(delta: float) -> void:
	# Get movement input
	var direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()

	# Move the player
	velocity = direction * SPEED
	move_and_slide()

	if direction == Vector2.ZERO:
		# If the player isn't moving, switch to idle animation based on last direction
		animated_sprite.play(last_direction)
	else:
		# Player is moving, check for direction and play corresponding animation
		if abs(direction.x) > abs(direction.y):  # Horizontal movement priority
			if direction.x > 0:
				animated_sprite.play("walk_right")
				last_direction = "idle_right"
			else:
				animated_sprite.play("walk_left")
				last_direction = "idle_left"
		else:
			if direction.y > 0:
				animated_sprite.play("walk_down")
				last_direction = "idle_down"
			else:
				animated_sprite.play("walk_up")
				last_direction = "idle_up"
