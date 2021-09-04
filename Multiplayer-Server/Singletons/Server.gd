extends Node

var network = NetworkedMultiplayerENet.new()
var port = 1909
var max_clients = 100


func _ready():
	CreateServer()
	
	get_tree().connect("network_peer_connected",self,"_player_connected")
	get_tree().connect("network_peer_disconnected",self,"_player_disconnected")
func CreateServer():
	network.create_server(port,max_clients)
	get_tree().set_network_peer(network)
	print("Started Server")
#	var s = load("res://Main/Test.tscn").instance()
#	call_deferred("add_child",s)
func _player_connected(player_id):
	_register_player(player_id)
	print("User:" + str(player_id) + " Connected")
	print("Players Online: ",NetworkSync.players_online)
#	var player = preload("res://Player/Player.tscn").instance()
#	player.name = str(player_id)
#	get_tree().get_root().get_node("Test").add_child(player)
func _player_disconnected(player_id):
	NetworkSync.remove_online_player(player_id)
	print("User:" + str(player_id) + " Disconnected")
	print("Players Online: ",NetworkSync.players_online)
	NetworkSync.check_player_in_lobby(player_id)
#	get_tree().get_root().get_node("Test").get_node(str(player_id)).queue_free()
func _register_player(id):
	NetworkSync.add_online_player(id)

