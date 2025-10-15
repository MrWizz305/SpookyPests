extends Node2D

@export var day_length: float = 20
@export var night_start: float = 1.0 / 3.0
@export var night_end: float = 2.0 / 3.0
@export var darkness: int = 170
@export var overlay: ColorRect

var t: float = 0.0
var is_night: bool = false

signal night_started
signal day_started

var was_night := false


var fade_ratio: float = 0.05 

func _process(delta: float) -> void:
	t = fmod(t + delta / day_length, 1.0)

	var alpha := overlay.color.a
	var night_alpha := float(darkness) / 255.0

	if t > night_start and t < night_end:
		is_night = true
		var fade_in_end := night_start + (night_end - night_start) * fade_ratio
		var fade_out_start := night_end - (night_end - night_start) * fade_ratio

		if t < fade_in_end:

			var progress := (t - night_start) / (fade_in_end - night_start)
			alpha = lerp(0.0, night_alpha, clamp(progress, 0.0, 1.0))
		elif t > fade_out_start:

			var progress := (t - fade_out_start) / (night_end - fade_out_start)
			alpha = lerp(night_alpha, 0.0, clamp(progress, 0.0, 1.0))
		else:

			alpha = night_alpha

	elif t >= night_end:
		is_night = false
		alpha = 0.0
	else:
		is_night = false
		alpha = 0.0
	
	overlay.color.a = alpha
	
	if is_night and not was_night:
		emit_signal("night_started")
	elif not is_night and was_night:
		emit_signal("day_started")

	was_night = is_night
