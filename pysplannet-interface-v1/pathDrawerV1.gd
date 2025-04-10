extends Node2D

var time = 0.0
@onready var PathManager = $"../PathManager"
@onready var MapView = $".."

func _process(delta):
	time += delta
	if time > 0.2:
		queue_redraw()
		
func _draw():
	if PathManager == null:
		return
	var angle = PathManager.get_starting_direction()
	var pos = PathManager.get_starting_position()
	var commands = PathManager.get_path_commands()
	
	for cmd in commands:
		if cmd.command == "straight_line":

			var lastPos = pos
			pos += Vector2.from_angle(deg_to_rad(angle))*cmd.attribute1.to_float()*sign(cmd.attribute2.to_float())
			draw_line(lastPos, pos, Color.RED, 3.0)

		elif cmd.command == "curve":
			angle += cmd.attribute1.to_float()
