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
			add_child(current_crop)
			current_crop.position = Vector2.ZERO
			current_crop.scale= Vector2.ONE/global_scale
			current_crop.global_position= global_position
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
func on_crop_died():
	has_crop=false
func _on_input_event(_viewport, event, _shape_idx):
	print("received input")
	if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
		if has_crop:
			harvest_crop()
		else:
			plant()
	
