extends CharacterBody2D

enum PlayerState {
	idle,
	run,
	jump,
	dead
}
@onready var player: AnimatedSprite2D = $Skin

var SPEED = 100
var JUMP_VELOCITY = -400
var jump_count = 0
var max_jump = 2

var status: PlayerState 

func _ready() -> void:
	go_to_idle_state()

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	if position.y > 200 and status != PlayerState.dead:
		go_to_dead_state()
	match status:
		PlayerState.idle:
			idle_state(delta)
		PlayerState.run:
			run_state(delta)
		PlayerState.jump:
			jump_state(delta)
		PlayerState.dead:
			dead_state(delta)
	move_and_slide()

func go_to_idle_state():
	status = PlayerState.idle
	player.play("idle")
	
func go_to_run_state():
	status = PlayerState.run
	player.play("run")
	
func go_to_jump_state():
	status = PlayerState.jump
	player.play("jump")
	velocity.y = JUMP_VELOCITY
	jump_count += 1
	
func go_to_dead_state():
	status = PlayerState.dead
	player.play("dead")
	velocity = Vector2.ZERO
	await get_tree().create_timer(1).timeout
	get_tree().reload_current_scene()
	

func idle_state(delta):
	move()
	if velocity.x != 0:
		go_to_run_state()
		return
		
	if Input.is_action_just_pressed("ui_up"):
		go_to_jump_state()
		return
	
func run_state(delta):
	move()
	if velocity.x == 0:
		go_to_idle_state()
		return
	if Input.is_action_just_pressed("ui_up"):
		go_to_jump_state()
		return
	
func jump_state(delta):
	move()
	if Input.is_action_just_pressed("ui_up") && jump_count < max_jump:  
		go_to_jump_state()
		return
	if is_on_floor():
		jump_count = 0
		if velocity.x != 0:
			go_to_run_state()
		else:
			go_to_idle_state()
		return
func dead_state(_delta):
	pass

	
func move():
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction < 0:
		player.flip_h = true
	elif direction > 0:
		player.flip_h = false
		


func _on_hit_box_area_entered(area: Area2D) -> void:
	if velocity.y > 0:
		area.get_parent().take_damage()
		go_to_jump_state()
	else:
		go_to_dead_state()
		
