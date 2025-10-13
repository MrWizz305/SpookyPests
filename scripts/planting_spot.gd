extends Area2D
@export var crop_scene: PackedScene
var has_crop := false

func can_plant():
	return true

var current_crop=null
func plant():
	if can_plant():
		if has_crop:
			return
		else:
			current_crop = crop_scene.instantiate()
			get_parent().add_child(current_crop)
			current_crop.global_position = global_position
			has_crop = true
			print("Seed has been planted and removed from inventory")
	else:
		print("Not enough seeds")

func harvest_crop():
	if not has_crop or not is_instance_valid(current_crop):
		return
	elif current_crop.harvest():
		has_crop=false
		current_crop=null
		print("Crop harvested")
	else:
		pass
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
		if has_crop:
			harvest_crop()
		else:
			plant()
	
