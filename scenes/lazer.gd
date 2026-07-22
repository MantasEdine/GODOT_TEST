extends Area2D


@export var speed := 500
# how much hp one hit removes; meteors get take_damage(damage) called on them
@export var damage : int = 1

func _ready():
	var tween = create_tween()
	tween.tween_property($Sprite2D,'scale',Vector2(1,1),0.2).from(Vector2(0,0))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Vector2.UP rotated by our own rotation = fly wherever we're tilted
	# (rotation gets set by level.gd when we spawn; 0 still means straight up)
	position += Vector2.UP.rotated(rotation) * speed * delta


func _on_area_entered(area: Area2D) -> void:
	# our collision_mask only sees layer 2 (Meteor), so 'area' is always a meteor
	# has_method is a safety net in case something without take_damage sneaks in
	if area.has_method("take_damage"):
		area.take_damage(damage)
	# one lazer = one hit, so the lazer is used up
	queue_free()
