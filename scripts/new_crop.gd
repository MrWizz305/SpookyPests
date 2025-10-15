extends Node2D
@onready var sprite = $Sprite2D




const time_to_mature= 120
var time_planted=0
var mature=false
var alive=true
var being_attacked=false
var attack_time=0
var stage:= 'baby'

const baby_coords=Rect2(303.023, 8.286, 12.502, 12.502)
const adult_coords=Rect2(317.626, 7.27, 15.405, 15.405)

func _ready():
	sprite.region_rect = baby_coords
	sprite.region_enabled = true
	if not is_in_group("crops"):
		add_to_group("crops")
		print(name, "added to group 'crops'")

func _process(delta):
	if not alive:
		return
	if not mature:
		time_planted += delta 
		if time_planted >= time_to_mature:
			age()
	if being_attacked and alive:
		attack_time+=delta
		
		if mature:
			if (attack_time < 5.0):
				sprite.region_rect=adult_coords
			elif attack_time < 12.0:
				sprite.region_rect=baby_coords
			else:
				die()
		else:
			if attack_time > 7.0:
				die()
	elif not being_attacked and attack_time > 0:
		attack_time -= delta * 2   
		if attack_time < 0:
			attack_time = 0

		if attack_time < 5.0:
			sprite.region_rect = adult_coords
		elif attack_time < 12.0:
			sprite.region_rect = baby_coords
	else:
		attack_time=0

		

func age():
	mature=true
	sprite.region_rect= adult_coords
	print("Newcrop has grown")

func harvest():
	if mature:
		queue_free()
		return true
	elif not mature:
		print("nuh uh")
		return false

func die():
	alive=false
	being_attacked=false
	if get_parent().has_method("on_crop_died"):
		get_parent().on_crop_died()
	queue_free()
	
