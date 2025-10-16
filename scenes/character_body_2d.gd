extends CharacterBody2D
@export var speed=100
@onready var animated_sprite=$AnimatedSprite2D
var player=null
@export var inv: Inv

@export var attack_range: float = 50.0
@export var attack_damage: int = 100.0/3.0
@onready var attack_timer: Timer = $AttackTimer
var can_attack = true
var isattacking=false

	
func _physics_process(delta):
		if isattacking:
			return
		var input_direction = Input.get_vector("left","right","up","down")
		move_and_slide()
		velocity = input_direction *speed
		if not input_direction.is_zero_approx():
				animated_sprite.play("walk")
				if input_direction.x < 0:
					animated_sprite.flip_h = true
				elif input_direction.x > 0:
					animated_sprite.flip_h = false
		
		
		else:
			
			animated_sprite.play("idle")


func _input(event):
	if event.is_action_pressed('Attack') and can_attack:
		print("Attacking")
		attack()
func attack():
	can_attack= false
	isattacking=true
	attack_timer.start()
	animated_sprite.play("scythe")
	var ghosts= get_tree().get_nodes_in_group('Ghosts')
	for ghost in ghosts:
		if global_position.distance_to(ghost.global_position) <= attack_range:
			ghost.take_damage(attack_damage)
func _on_AttackTimer_runout():
	can_attack= true
	isattacking=false
	


func _on_attack_timer_timeout() -> void:
	can_attack=true
	isattacking=false
