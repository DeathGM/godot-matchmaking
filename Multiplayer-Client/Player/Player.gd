extends KinematicBody2D

var Name = Global.player_name
func _ready():
	if is_network_master():
		$UI/Return.show()
		$Label.text = str(Name)
		var camera = Camera2D.new()
		camera.current = true
		add_child(camera)

func _physics_process(delta):
	if is_network_master():
		var dir = Vector2() 
		dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		dir.normalized()
		rpc_unreliable_id(1,"update_transform",global_transform)
		var motion = dir * 100 * delta
		move_and_collide(motion)
			  

remote func Get_transform(transform):
	if not is_network_master():
		global_transform = transform



func _on_Return_pressed():
	var id = get_tree().get_network_unique_id()
	get_parent().end_game(id,true)
