extends RigidBody2D
var main_node
var speed
var velocity = Vector2(0,0)

func _ready():
	set_fixed_process(true)
	main_node = get_node("/root/main")
	speed = main_node.car_speed

func _fixed_process(delta):

	velocity = Vector2(sin(get_rot()) * -speed, cos(get_rot()) * -speed)
	set_linear_velocity(get_linear_velocity() + velocity * delta)

func hit():
	get_node("anim").play("hit")