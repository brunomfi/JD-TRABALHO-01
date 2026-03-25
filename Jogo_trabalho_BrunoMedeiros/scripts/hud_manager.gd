extends Control

@onready var score_count: Label = $Container/score_container/score_count as Label
@onready var fruits_count: Label =$Container/fruits_container/fruits_count as Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fruits_count.text = str(Hud.fruits)
	score_count.text = str(Hud.score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fruits_count.text = str(Hud.fruits)
	score_count.text = str(Hud.score)
	
