extends Node2D
var cam_to_player = Vector2(0,0)

func _ready():
	randomize()

	cam_to_player = get_node("player").get_pos() - get_node("Camera2D").get_pos()
	set_process(true)

func _process(delta):
	var cam_pos = get_node("Camera2D").get_pos()
	cam_pos.y = get_node("player").get_pos().y - cam_to_player.y
	get_node("Camera2D").set_pos(cam_pos)

func _on_killer_body_enter( body ):
	if body.is_in_group("car"):
		var a = (randi() % 4 + 1) * 100.0
		if a > 200:
			a += 40
		body.set_pos(Vector2(a,get_node("Camera2D").get_pos().y - 800))
		body.set_angular_velocity(0)
		body.set_rot(0)
#		body.set_pos(Vector2(randf() * 350 + 100, get_node("Camera2D").get_pos() - 200))
