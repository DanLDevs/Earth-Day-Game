extends CharacterBody2D

const SPEED = 130.0 
const GRAVITY = -600.0 # Simulated gravity pulling the player down

@onready var animated_sprite = $AnimatedSprite2D
@onready var hurtBox = $hurtBox
@onready var hotbar = $"../CanvasLayer/Hotbar"
@onready var score_gui = $"../CanvasLayer/ScoreGui"

@export var inventory: Inventory

var last_direction = "idle_down"  # Default idle direction

# Add a variable to track if the player is near trash/recycling bins
var near_bin = null
#var current_trash_type = null # Track what trash is currently selected in inventory

var isHurt: bool = false

func _ready():
	if inventory:
		inventory.inventory_full.connect(_on_inventory_full)
		
func _on_inventory_full(item: InventoryItem):
	var feedback_gui = get_node("../CanvasLayer/FeedbackGui")
	if feedback_gui:
		var item_name = item.name if item.name else "this item"
		feedback_gui.show_feedback("Cannot carry more than 5 of this " + item_name + ".")

func _physics_process(delta: float) -> void:
	# Get movement input
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	
	# Move the player
	velocity = direction * SPEED
	move_and_slide()
	
	if direction == Vector2.ZERO:
		# If player is not moving, switch to idle animation based on last direction
		animated_sprite.play(last_direction)
	else:
		# Determine movement direction and play corresponding animation
		if abs(direction.x) > abs(direction.y): # Prioritize horizontal movement
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
		
func _on_bin_area_entered(area):
	if area.is_in_group("bin"):
		near_bin = area
		hotbar.near_bin = area
		#print("Entered", area.name)
		
func _on_bin_area_exited(area):
	if area == near_bin:
		near_bin = null
		hotbar.near_bin = null
		#print("Exited bin area", area.name)
		
func _on_hurt_box_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory, score_gui)

func player():
	pass
