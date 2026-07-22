extends Area2D
var speed : int
var rotation_speed : int
var direction : float
var hp : int  # hit points; how many lazer hits this meteor survives




func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	
	# meteor.gd, in _ready
	var colors = ["Brown", "Grey"]
	var sizes = {"big": 4, "med": 3, "small": 2, "tiny": 2}
	# hp per size: bigger meteor = more lazer hits to destroy (lazers deal 1 each)
	var size_hp = {"big": 4, "med": 3, "small": 2, "tiny": 1}
	var size = sizes.keys().pick_random()
	hp = size_hp[size]
	var path = "res://PNG/Meteors/meteor%s_%s%d.png" % [colors.pick_random(), size, randi_range(1, sizes[size])]
	$Sprite2D.texture = load(path)
	
	
	var width = get_viewport().get_visible_rect().size[0]
	var random_x = rng.randi_range(0,width)
	var random_y = rng.randi_range(-150,-50)
	position = Vector2(random_x,random_y)
	speed = rng.randi_range(300,500)
	direction = rng.randf_range(-0.3,0.3)
	rotation_speed = rng.randi_range(40,100)
	
	
func _process(delta):
	position += Vector2(direction,1.0) * speed * delta
	rotation_degrees += rotation_speed * delta


func _on_body_entered(body: Node2D) -> void:
	print("hit by: ", body.name)


# lazers call this when they hit us; the meteor dies at 0 hp
func take_damage(amount : int) -> void:
	# already dead but not yet removed from the tree (queue_free waits until
	# the end of the frame) -> ignore extra hits so we can't "die twice"
	if hp <= 0:
		return
	hp -= amount
	if hp <= 0:
		queue_free()
	else:
		# quick flash so the player sees the hit landed: modulate is multiplied
		# with the texture, so an overbright color washes the sprite out white,
		# then the tween fades it back to normal (Color.WHITE = no tint)
		var tween = create_tween()
		tween.tween_property($Sprite2D,'modulate',Color.WHITE,0.15).from(Color(5, 5, 5))
