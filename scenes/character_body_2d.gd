extends CharacterBody2D
@export var speed=100
@onready var animated_sprite=$AnimatedSprite2D
var player=null



	
func _physics_process(delta):
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
