extends Node2D


var opponent_server = 0
var opponent_client = 0


func _ready():
	var player1 = preload("res://Player/Player.tscn").instance()
	player1.name = str(opponent_server)
	add_child(player1)
	var player2 = preload("res://Player/Player.tscn").instance()
	player2.name = str(opponent_client)
	add_child(player2)
