extends Node2D

var time = 0.0
var setting_scale = false
@onready var PathManager = %PathManager
@onready var MapView = $".."
@onready var camera = %MapViewCamera
@onready var tools = %tools

func set_map_scale():
	print("meowww")
	setting_scale = true
	tools.set_tools_enabled(true)



func _process(delta):
	time += delta
	if time > 0.2:
		queue_redraw()
		
func _draw():
	if PathManager == null:
		return
	var angle = PathManager.get_starting_direction()
	var pos = MapView.cm_to_pixels(PathManager.get_starting_position())
	var commands = PathManager.get_path_commands()
	
	for cmd in commands:
		if cmd.command == "straight_line":
			var lastPos = pos
			pos += Vector2.from_angle(deg_to_rad(angle))*MapView.cm_to_pixels_float(cmd.attribute1.to_float())*sign(cmd.attribute2.to_float())
			draw_path_line(pos,lastPos,cmd.attribute2)
		elif cmd.command == "curve":
			angle += cmd.attribute1.to_float()
		elif cmd.command == "set_pos":
			pos = MapView.cm_to_pixels(Vector2(cmd.attribute1.to_float(),cmd.attribute2.to_float()))
			angle = cmd.attribute3.to_float()

func draw_path_line(pos1: Vector2, pos2: Vector2, sign):
	var arrows_displacement = fmod(time,1)
	var stroke_modifier = max(camera.get_zoom_as_float(),1)
	
	var arrow_pos = pos2
	var dist = arrows_displacement*60
	var dir =  (pos1 - pos2).normalized()
	if(sign(sign.to_float()) == 1):
		draw_line(pos1, pos2, Color.YELLOW,6.0/stroke_modifier)
		draw_line(pos1, pos2, Color.ORANGE, 4.0/stroke_modifier)
		draw_line(pos1, pos2, Color.RED, 2.0/stroke_modifier)
		
		while (dist<pos1.distance_to(pos2)):
			draw_arrow_triangle(arrow_pos + dir * dist, dir, 11 / stroke_modifier, Color.YELLOW)
			draw_arrow_triangle(arrow_pos + dir * dist, dir, 9 / stroke_modifier, Color.ORANGE)
			draw_arrow_triangle(arrow_pos + dir * dist, dir, 8 / stroke_modifier, Color.RED)
			dist += 60
	else:
		draw_line(pos1, pos2, Color.SKY_BLUE,6.0/stroke_modifier)
		draw_line(pos1, pos2, Color.BLUE, 4.0/stroke_modifier)
		draw_line(pos1, pos2, Color.DARK_BLUE, 2.0/stroke_modifier)
		while (dist<pos1.distance_to(pos2)):
			draw_arrow_triangle(arrow_pos + dir * dist, -dir, 11 / stroke_modifier, Color.SKY_BLUE)
			draw_arrow_triangle(arrow_pos + dir * dist, -dir, 9 / stroke_modifier, Color.BLUE)
			draw_arrow_triangle(arrow_pos + dir * dist, -dir, 8 / stroke_modifier, Color.DARK_BLUE)
			dist += 60
	

func draw_arrow_triangle(center: Vector2, direction: Vector2, size: float, color: Color):
	var dir = direction.normalized()
	var perp = dir.orthogonal()  # perpendicular to direction

	var tip = center + dir * size
	var base_left = center - dir * size * 0.5 + perp * size * 0.5
	var base_right = center - dir * size * 0.5 - perp * size * 0.5

	var points = [tip, base_left, base_right]
	draw_polygon(points, [color])
