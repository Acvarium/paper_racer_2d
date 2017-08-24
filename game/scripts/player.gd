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
var touch = false
var touch_pos = Vector2(0,0)
var drag_pos = Vector2(0,0)
var dead = false


const MAX_SPEED = 800
const MIN_SPEED = 600
var max_speed

func _ready():

	set_process_input(true)
	set_fixed_process(true)
	speed = MIN_SPEED
	start_pos = get_pos()
	max_speed = MAX_SPEED
	get_node("SamplePlayer").get_sample_library().get_sample("engine").set_loop_format(0)
	engine_sound = get_node("SamplePlayer").play("engine")

func _fixed_process(delta):
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
		if Input.is_action_pressed("ui_left") or (touch and touch_pos.x < 270):
			move_y = -speed_y
			set_rot(PI/15)
		if Input.is_action_pressed("ui_right") or (touch and touch_pos.x > 270):
			move_y = speed_y
			set_rot(-PI/15)
	move_y = move_y * 0.7
	if life > 0:
		var rot = get_rot()
		rot = rot * 0.7
		set_rot(rot)
	else:
		speed = 0
	var c_pos = get_node("cam_pointer").get_pos()
	c_pos.y = -speed/6
	get_node("cam_pointer").set_pos(c_pos)
	var pos = get_pos()
#	pos.x += move_y * delta
		
	velocity.x += move_y * delta
	velocity.y = -speed * delta

	set_linear_velocity(velocity * 80)
	last_velocity = get_linear_velocity()
	get_node("Label").set_text(str("%02d" % life))
	var pitch = ((get_linear_velocity().length() - MIN_SPEED) / (MAX_SPEED - MIN_SPEED)) * 0.3 + 1 + (randf() * 0.1)
	get_node("SamplePlayer").set_pitch_scale(engine_sound, pitch)
	get_node("Label1").set_text(str("%02d" % get_pos().x))

func _input(event):
#	if event.is_action_pressed("ui_left"):
#		move_y = -speed_y
#	elif event.is_action_pressed("ui_right"):
#		move_y = speed_y
#	elif event.is_action_released("ui_left") or event.is_action_released("ui_right"):
#		move_y = 0
	
	if event.type == InputEvent.SCREEN_TOUCH:
		if event.pressed:
			touch = true
			touch_pos = event.pos
		else:
			touch = false
	
func _on_front_body_enter( body ):
	if body.is_in_group("car") and !dead:
		var hit_force = (last_velocity - get_linear_velocity()).length()
		life = 0
		dead = true
		get_node("anim").play("squ")
		get_node("SamplePlayer").play("hit")
		body.hit()
		if life < 1:
			life = 0
			max_speed = 0
			get_node("Timer").start()

		
func _on_l_side_body_enter( body ):
	if body.is_in_group("car"):
		pass

func _on_r_side_body_enter( body ):
	if body.is_in_group("car"):
		pass


func _on_player_body_enter( body ):
	if body.is_in_group("car"):
		pass

func _on_Timer_timeout():
	get_node("Sprite").set_frame(sprite)
	max_speed = MAX_SPEED
	life = 100
	dead = false
#	set_scale(Vector2(1,1))
	get_node("anim").play("blink")
	get_node("restart_timer").start()


func _on_restart_timer_timeout():
	max_speed = MAX_SPEED
	speed = MIN_SPEED
