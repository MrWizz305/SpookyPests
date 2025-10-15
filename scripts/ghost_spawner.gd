extends Node2D

@export var crops_per_ghost=3
@export var ghost_scene: PackedScene
@export var player: Node2D
@export var spawn_radius: float = 500.0
@export var min_spawn_distance: float = 200.0

func spawn_ghosts():
	
	var crops= get_tree().get_nodes_in_group("crops")

	if crops.is_empty():
		print("no crops, no ghosts")
		return
	var num_ghosts = int(ceil(float(crops.size()) / crops_per_ghost))
	num_ghosts=max(1,num_ghosts)
	print("Spawning", num_ghosts, "ghosts for", crops)
	for i in range (num_ghosts):
		var ghost= ghost_scene.instantiate()
		var angle= randf() * TAU
		var distance= randf_range(min_spawn_distance, spawn_radius)
		var offset= Vector2(cos(angle), sin(angle))*distance
		ghost.global_position = player.global_position + offset
		get_tree().current_scene.add_child(ghost)
		


func _on_game_night_started() -> void:
	print("The pests are back, defend your crops!")
	spawn_ghosts()


func _on_game_day_started() -> void:
	print("The sun is coming up, the ghosts are vanishing")
	for ghost in get_tree().get_nodes_in_group("Ghosts"):
		ghost.queue_free()
