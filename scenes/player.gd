extends CharacterBody2D

@export var speed : int = 500
# weapon_level 1..4 picks the firing pattern: single/double/triple/5-spread
# @export_range clamps it in the Inspector so you can't accidentally type 7
@export_range(1, 4) var weapon_level : int = 1
# the signal now also carries an angle so level.gd can tilt spread lazers
signal lazer(pos, angle)
var can_shoot : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction  * speed 
	move_and_slide()

	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot_lazers()
		can_shoot = false
		$Lazer_Timer.start()
		
	


# fires a pattern of lazers based on weapon_level
func shoot_lazers() -> void:
	# each entry is [sideways_offset_px, angle_degrees] for ONE lazer
	# angle 0 = straight up, negative = tilted left, positive = tilted right
	var shots : Array = []
	match weapon_level:
		1: shots = [[0, 0]]                                            # single
		2: shots = [[-20, 0], [20, 0]]                                 # double (parallel)
		3: shots = [[0, 0], [-20, -8], [20, 8]]                        # triple (fan)
		4: shots = [[0, 0], [-15, -8], [15, 8], [-30, -16], [30, 16]]  # 5-spread
	for shot in shots:
		# one signal per lazer; level.gd does the actual spawning
		# deg_to_rad converts degrees to radians because Node2D.rotation uses radians
		lazer.emit($LazerStartingPosition.global_position + Vector2(shot[0], 0), deg_to_rad(shot[1]))


# power-ups will call this later to raise the weapon level
func upgrade_weapon() -> void:
	# clamp keeps the value between 1 and 4 no matter how often it's called
	weapon_level = clamp(weapon_level + 1, 1, 4)


func _on_lazer_timer_timeout() -> void:
	can_shoot = true # Replace with function body.
