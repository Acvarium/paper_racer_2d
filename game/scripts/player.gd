extends RigidBody2D
#extends KinematicBody2D
var move_y = 0
var speed_y = 450
var start_pos = Vector2(0,0)
var speed
var last_velocity = Vector2(0,0)
var life = 100
var sprite = 0
var row = 5
var engine_sound 
var ray

const MAX_SPEED = 1000
const MIN_SPEED = 500
var max_speed
export var bot_mode = 1
var command = 0

func _ready():
	set_fixed_process(true)
	speed = MIN_SPEED
	start_pos = get_pos()
	max_speed = MAX_SPEED
	get_node("SamplePlayer").get_sample_library().get_sample("engine").set_loop_format(1)
	engine_sound = get_node("SamplePlayer").play("engine")
	ray = get_node("RayCast2D")
	ray.add_exception(self)

func _fixed_process(delta):
	if ray.is_colliding():
		print("adsdafdagf")
		if ray.get_collider().is_in_group("car"):
			print("adsdafdagf")
			command = 1
			if get_pos().x < 200:
				command = 2
	else:
		command = 0
		
	var velocity = Vector2(0,0)
	if speed > max_speed:
		speed -= 5
	if speed < 0:
		speed = 0
	if life > 0:
		if Input.is_action_pressed("ui_up"):
			if speed < max_speed:
				speed += 10
		elif Input.is_action_pressed("ui_down"):
			if speed > MIN_SPEED:
				speed -= 20
		else:
			if speed > MIN_SPEED:
				speed -= 5
		if Input.is_action_pressed("ui_left") or (bot_mode == 1 and command == 1):
			move_y = -speed_y
			set_rot(PI/15)
		if Input.is_action_pressed("ui_right") or (bot_mode == 1 and command == 2):
			move_y = speed_y
			set_rot(-PI/15)
	move_y = move_y * 0.7
	var rot = get_rot()
	rot = rot * 0.7
	set_rot(rot)
	ray.set_rot(-rot*2)
	var pos = get_pos()
#	pos.x += move_y * delta
	velocity.x += move_y * delta
	velocity.y = -speed * delta

	set_linear_velocity(velocity * 80)
	last_velocity = get_linear_velocity()
	get_node("Label").set_text(str("%02d" % life))
	var pitch = ((get_linear_velocity().length() - MIN_SPEED) / (MAX_SPEED - MIN_SPEED)) * 0.3 + 1
	get_node("SamplePlayer").set_pitch_scale(engine_sound, pitch)
	get_node("Label1").set_text(str("%02d" % get_pos().x))
	
func _input(event):
	if event.is_action_pressed("ui_left"):
		move_y = -speed_y
	elif event.is_action_pressed("ui_right"):
		move_y = speed_y
	elif event.is_action_released("ui_left") or event.is_action_released("ui_right"):
		move_y = 0

func _on_front_body_enter( body ):
	if body.is_in_group("car"):
		var hit_force = (last_velocity - get_linear_velocity()).length()
		life -= hit_force / 20
#		set_scale(Vector2(1 + ((1 - life / 100.0) * 0.1),0.9 + life / 1000.0))
		if hit_force > 400:
			get_node("anim").play("squ")
		print("front ", hit_force)
		if life < 50:
			get_node("Sprite").set_frame(sprite + row)
		if life < 1:
			get_node("Sprite").set_frame(sprite + row * 2)
			life = 0
			max_speed = 0
			speed = speed / 2
			get_node("Timer").start()
		
func _on_l_side_body_enter( body ):
	if body.is_in_group("car"):
		print("left")


func _on_r_side_body_enter( body ):
	if body.is_in_group("car"):
		print("right")


func _on_player_body_enter( body ):
	if body.is_in_group("car"):
		pass

func _on_Timer_timeout():
	get_node("Sprite").set_frame(sprite)
	max_speed = MAX_SPEED
	life = 100
#	set_scale(Vector2(1,1))
	get_node("anim").play("blink")
