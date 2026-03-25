extends CharacterBody2D
enum EsqueletoState {
	walk,
	dead
}
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $HitBox



const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var status: EsqueletoState

func _ready() -> void:
	go_to_walk_state()
	
func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
		
	match status:
		EsqueletoState.walk:
			walk_state(delta)
		EsqueletoState.dead:
			dead_state(delta)

	move_and_slide()

func go_to_walk_state():
	status = EsqueletoState.walk
	anim.play("walk")
	
	
func go_to_dead_state():
	status = EsqueletoState.dead
	anim.play("dead")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	Hud.score += 100 
	
func walk_state(delta):
	pass
func dead_state(delta):
	pass
func take_damage():
	go_to_dead_state()
