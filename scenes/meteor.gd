extends Area2D
var speed : int
var rotation_speed : int
var direction : float




func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	
	# meteor.gd, in _ready
	var colors = ["Brown", "Grey"]
	var sizes = {"big": 4, "med": 3, "small": 2, "tiny": 2}
	var size = sizes.keys().pick_random()
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
