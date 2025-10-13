extends Node2D
@onready var sprite = $Sprite2D

const time_to_mature= 120
var time_planted=0
var mature=false

const baby_coords=Rect2(303.023, 8.286, 12.502, 12.502)
const adult_coords=Rect2(317.626, 7.27, 15.405, 15.405)

func _ready():
	sprite.region_rect = baby_coords
	sprite.region_enabled = true

func _process(delta):
	if not mature:
		time_planted += delta 
		if time_planted >= time_to_mature:
			age()

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
	
	
