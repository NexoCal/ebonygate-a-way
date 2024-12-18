extends Node

@export var pipes_scene : PackedScene

var game_running : bool
var game_over : bool
var scroll
var score
const SCROLL_SPEED : int = 4
var screen_size : Vector2i
var ground_height : int
var pipes : Array
const PIPE_DELAY : int = 100
const PIPE_RANGE : int = 900

# Called when the node enters the scene tree for the first time.



func _ready():
	screen_size = get_window().size
	ground_height = $ground.get_node("Sprite2D").texture.get_height()
	new_game()

func new_game():
	#reset variables
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$score.text = "SCORE : " + str(score)
	$gameOver.hide()
	get_tree().call_group("pipess", "queue_free")
	pipes.clear()
	genPipes()
	$cat.reset()
	
func _input(event):
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				$cat.jumping
				$cat.jump()

func start_game():
	game_running = true
	$cat.jumping = true
	$cat.jump()
	
	$pipestime.start()

func _process(delta):
	
	
	if game_running:
		scroll += SCROLL_SPEED+3
		if scroll >= screen_size.x:
			scroll = 0
		$ground.position.x = -scroll + 200 * delta 
		
		for pipe in pipes:
			pipe.position.x -= (SCROLL_SPEED + 300) * delta
			
		if $bgMusic.playing == false:
			$bgMusic.play()


func _on_pipestime_timeout():
	genPipes()
	
func genPipes():
	var pipe = pipes_scene.instantiate()
	pipe.position.x = (screen_size.x + PIPE_DELAY)
	pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-600, -300)
	pipe.hit.connect(cat_hit)
	pipe.scored.connect(scored)
	add_child(pipe)
	pipes.append(pipe)
	
func scored():
	score += 1
	$score.text = "SCORE : " + str(score)
	
func stop_game():
	$pipestime.stop()
	$cat.jumping = false
	game_running = false
	game_over = true
	$gameOver.show()
	
func cat_hit():
	$cat.falling = true
	stop_game()
	
func _on_ground_hit():
	$cat.falling = false
	stop_game()
	
	
func _on_game_over_restart() -> void:
	
	new_game()
	game_running = true
	$cat.jumping = true
	$cat.jump()
	$pipestime.start()



func _on_startscene_start_game() -> void:
	$startscene/menumusic.stop()
	$startscene.hide()
	start_game()
