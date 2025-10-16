extends CharacterBody2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

@export var speed := 50.0
var target_crop: Node2D = null
@export var max_health: int = 40
var current_health: int

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _on_body_entered(body):
	if body.is_in_group("crops"):
		body.being_attacked = true

func _on_body_exited(body):
	if body.is_in_group("crops"):
		body.being_attacked = false


func _ready():
	add_to_group("Ghosts")
	find_nearest_crop()
	current_health=max_health
	

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(target_crop) or (target_crop and not target_crop.alive):
		find_nearest_crop()
		velocity = Vector2.ZERO
		
		if anim.animation!='idle':
			anim.play('idle')
		
		return
	var direction= (target_crop.global_position-global_position)
	var distance= direction.length()
	
	if distance > 10:
		velocity = direction.normalized() * speed
		move_and_slide()
		if anim:
			anim.flip_h = direction.x < 0
		if anim.animation!= 'Walking':
			anim.play('Walking')
	elif distance <=10 and target_crop:
		velocity = Vector2.ZERO
		attack_crop()
		if anim.animation!= 'Attack':
			anim.play('Attack')
	else:
		velocity= Vector2.ZERO
		if anim.animation!= 'idle':
			anim.play('idle')
	
	
func attack_crop():
	if target_crop and is_instance_valid(target_crop):
		if "being_attacked" in target_crop:
			target_crop.being_attacked=true
func find_nearest_crop():
	var crops = get_tree().get_nodes_in_group("crops")
	if crops.size() == 0:
		target_crop = null
		return

	var closest = crops[0]
	var best_dist = global_position.distance_to(closest.global_position)

	for c in crops:
		var d = global_position.distance_to(c.global_position)
		if d < best_dist:
			best_dist = d
			closest = c

	target_crop = closest

func take_damage(amount):
	current_health-=amount
	print("Ghost hit")
	if current_health<=0:
		die()
		
func die():
	velocity= Vector2.ZERO
	set_physics_process(false)
	set_process(false)
	if target_crop and is_instance_valid(target_crop):
		target_crop.being_attacked=false
	queue_free()
