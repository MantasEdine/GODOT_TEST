extends Node2D

var meteor_scene : PackedScene = load('res://scenes/meteor.tscn')
var lazer_scene : PackedScene = load('res://scenes/lazer.tscn')


func _on_meteor_timer_timeout() -> void:
	var meteor = meteor_scene.instantiate()
	$Meteors.add_child(meteor)


func _on_player_lazer(pos) -> void:
	var lazer = lazer_scene.instantiate()
	$Lazers.add_child(lazer)
	lazer.position = pos
