extends CharacterBody2D

@export var speed : int = 500
signal lazer(pos)
var can_shoot : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction  * speed 
	move_and_slide()

	if Input.is_action_just_pressed("shoot") and can_shoot:
		lazer.emit($LazerStartingPosition.global_position)
		can_shoot = false
		$Lazer_Timer.start()
		
	


func _on_lazer_timer_timeout() -> void:
	can_shoot = true # Replace with function body.
