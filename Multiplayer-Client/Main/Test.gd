extends Node2D
 
var player_won = false
func spawn_player(Name,pos,network):
	var player = load("res://Player/Player.tscn").instance()
	player.name = Name
	player.position = pos.position
	player.set_network_master(network)
	add_child(player)
func _process(delta):
	print("Instanced: ",NetworkSync.instanced.size())
	if NetworkSync.lobby_id != 0:
		if player_won == false: # Turn off this when true
			if !NetworkSync.lobby[NetworkSync.lobby_id].empty(): # If there only 1 player left
				for i in NetworkSync.lobby[NetworkSync.lobby_id]:
					if !NetworkSync.lobby[NetworkSync.lobby_id].has(NetworkSync.opponent_client):
						end_game(NetworkSync.opponent_server,true)
					elif !NetworkSync.lobby[NetworkSync.lobby_id].has(NetworkSync.opponent_server):
						end_game(NetworkSync.opponent_client,true)

			if  NetworkSync.instanced.size() < NetworkSync.lobby[NetworkSync.lobby_id].size()  :#If players not instanced
				for i in NetworkSync.lobby[NetworkSync.lobby_id]:
					if i == NetworkSync.opponent_server and !NetworkSync.instanced.has(i):
						if str(i) != str(get_tree().get_network_unique_id()) :
							spawn_player(str(i),$Position2D,i)
							NetworkSync.instanced.append(i)
						elif str(i) == str(get_tree().get_network_unique_id()):
							spawn_player(str(i),$Position2D,i)
							NetworkSync.instanced.append(i)
						
					elif i == NetworkSync.opponent_client and !NetworkSync.instanced.has(i):
						if str(i) != str(get_tree().get_network_unique_id()) :
							spawn_player(str(i),$Position2D2,i)
							NetworkSync.instanced.append(i)
						elif str(i) == str(get_tree().get_network_unique_id()):
							spawn_player(str(i),$Position2D2,i)
							NetworkSync.instanced.append(i)
	#		print("lobby: ",NetworkSync.lobby[NetworkSync.lobby_id].size())
	#		print("instanced: ",NetworkSync.instanced.size())
			if NetworkSync.lobby[NetworkSync.lobby_id].size() < NetworkSync.instanced.size():
				for i in NetworkSync.instanced:
					if i == NetworkSync.opponent_server and !NetworkSync.instanced.has(i):
						if str(i) != str(get_tree().get_network_unique_id()) :
							get_node(str(i)).queue_free()
							NetworkSync.instanced.erase(i)
						elif str(i) == str(get_tree().get_network_unique_id()):
							get_node(str(i)).queue_free()
							NetworkSync.instanced.erase(i)
						
					elif i == NetworkSync.opponent_client and !NetworkSync.instanced.has(i):
						if str(i) != str(get_tree().get_network_unique_id()) :
							get_node(str(i)).queue_free()
							NetworkSync.instanced.erase(i)
						elif str(i) == str(get_tree().get_network_unique_id()):
							get_node(str(i)).queue_free()
							NetworkSync.instanced.erase(i)
	  
func end_game(who_won,send):

	match who_won:
		NetworkSync.opponent_server:
			for i in get_children():
				if i.name == str(NetworkSync.opponent_client):
					i.queue_free()
		NetworkSync.opponent_client:
			for i in get_children():
				if i.name == str(NetworkSync.opponent_server):
					i.queue_free()
	$GUI/Popup/Label.text = "Game Finished"
	$GUI/Popup.popup_centered()

	player_won = true
	if send:
		NetworkSync.send_finished_game(NetworkSync.lobby_id,who_won)
	queue_free()
	NetworkSync.return_ui()
	pass

