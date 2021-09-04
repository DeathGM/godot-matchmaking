extends Control

var can_search:bool = true

func _ready():
	NetworkSync.instanced = []
	NetworkSync.lobby = {}
	$Username.text = Global.player_name
func _process(delta):
	if NetworkSync.opponent_server != 0:
		NetworkSync.enter_game()
	if NetworkSync.opponent_client != 0:
		NetworkSync.enter_game()
	pass
func _on_Search_pressed():
	if $Username.text == "":
		$Text.text = "Enter username pls!"
	else:
		Global.player_name = $Username.text
		if can_search:
			$Search.text = "Cancel"
			$Text.text = "Searching"
			$Search.disabled = false
			NetworkSync.search_game()
			can_search = false
		else:
			$Search.text = "Search"
			$Text.text = "Idle"		
			$Search.disabled = false
			NetworkSync.remove_search()
			can_search = true
	pass # Replace with function body.
