extends Node

var players_in_queue = []
var players_online = []
var game_lobby = {}

func _ready():
	randomize()
func add_online_player(id):
	players_online.append(id)
	rpc("reveiced_online_players",players_online)
func remove_online_player(id):
	players_online.erase(id)
	rpc("reveiced_online_players",players_online)
remote func get_online_players():
	rpc("reveiced_online_players",players_online)

remote func player_join_queue(player_id):
	players_in_queue.append(player_id)
	rpc_id(player_id,"get_queue",players_in_queue)
remote func player_leave_queue(player_id):
	players_in_queue.erase(player_id)
	rpc_id(player_id,"get_queue",players_in_queue)

func _process(delta):
	print("game_lobby: ",game_lobby)
	print("players_in_queue: ",players_in_queue)
	if players_in_queue.size() > 1:
		match_players(players_in_queue.pop_front(),players_in_queue.pop_front())
func match_players(a,b):
	randomize()
	players_in_queue.erase(a)
	players_in_queue.erase(b)

	var lobby_id = a
	game_lobby[lobby_id] = [a,b]
	
	rpc_id(a,"update_lobby",game_lobby)
	rpc_id(b,"update_lobby",game_lobby)
	rpc_id(a,"init_server",b,lobby_id)
	rpc_id(b,"init_client",a,lobby_id)
remote func enter_game(pa,pb):
	var world = preload("res://Main/Test.tscn").instance()
#	var player = preload("res://Player/Player.tscn").instance()
	world.name = str(pa)
	world.add_to_group(str(pa))
	world.opponent_server = pa
	world.opponent_client = pb
	get_tree().get_root().add_child(world)

func check_player_in_lobby(player_id):
	for i in game_lobby:

		if game_lobby[i].has(player_id):
			received_finished_game(i,player_id)

#	for i in game_lobby.values():
#		if i != null:
#			if i.has(player_id):
#				i.erase(player_id)
#				rpc("update_lobby",game_lobby)
remote func chck_pl_in_lob(player_id):
	check_player_in_lobby(player_id)
remote func received_finished_game(game_id,who):
	for i in game_lobby.keys():
		if i == game_id:
			var p1
			var p2
			if game_lobby[game_id][0]:
				p1 = game_lobby[game_id][0]
			if game_lobby[game_id].size() > 1:
				p2 = game_lobby[game_id][1]
			match who:
				p1:
					rpc_id(p2,"game_finished_bro",game_id)
				p2:
					rpc_id(p1,"game_finished_bro",game_id)
			for y in get_tree().get_nodes_in_group(str(p1)):
				y.queue_free()
			game_lobby.erase(i)
