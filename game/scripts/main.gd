extends Node2D
var cam_to_player = Vector2(0,0)
var player
var last_spawn
var lines = [110,270,426]
var car_speed = 400


func _ready():
	randomize()
	player = get_node("2d/player")
	cam_to_player = player.get_node("cam_pointer").get_global_pos() - get_node("2d/Camera2D").get_pos()
	set_fixed_process(true)

func _fixed_process(delta):
	var cam_pos = get_node("2d/Camera2D").get_pos()
	cam_pos.y = player.get_node("cam_pointer").get_global_pos().y - cam_to_player.y
	get_node("2d/Camera2D").set_pos(cam_pos)


func get_line(x):
	var A = (lines[1] - lines[0])/2 + lines[0]
	var B = (lines[2] - lines[1])/2 + lines[1]
	var C = (lines[3] - lines[2])/2 + lines[2]
	var line = 0
	if x > C:
		line = 3
	elif x > B:
		line = 2
	elif x > A:
		line = 1
	return line

func _on_killer_body_enter( body ):

	if body.is_in_group("car"):

		var a = (randi() % 4 + 1) * 100.0
		if a > 200:
			a += 40
		body.set_pos(Vector2(a,get_node("2d/Camera2D").get_pos().y - 800))
		body.set_angular_velocity(0)
		body.set_linear_velocity(Vector2(0,0))
		body.set_rot(0)
#		body.set_pos(Vector2(randf() * 350 + 100, get_node("Camera2D").get_pos() - 200))
