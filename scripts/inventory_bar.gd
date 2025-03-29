extends Control

const MAX_SLOTS = 10
@onready var slots = $HBoxContainer.get_children() # Get all slot nodes

var inventory = [] # Stores trash textures

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialize inventory slots as empty
	for slot in slots:
		slot.texture = null
		
func add_item(trash_texture: Texture):
	if inventory.size() < MAX_SLOTS:
		inventory.append(trash_texture)
		update_inventory_display()
	else:
		print("Inventory full!") # Debug message
		
func update_inventory_display():
	# Update slots with collected trash textures
	for i in range(MAX_SLOTS):
		if i < inventory.size():
			slots[i].texture = inventory[i]
		else:
			slots[i].texture = null # Empty slot if no item


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
