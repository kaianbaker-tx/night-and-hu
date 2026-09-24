extends Node2D

# How fast Night flies when you hold an arrow key.
const SPEED := 380.0

const SCREEN := Vector2(1152, 648)

var night_pos := Vector2(260, 324)   # where Night is
var flap := 0.0                      # makes the wings go up and down
var clouds := []                     # x, y, and how close (z) for each cloud


# This runs one time when the game starts.
func _ready() -> void:
	randomize()
	for i in 14:
		clouds.append(Vector3(randf() * SCREEN.x, randf() * SCREEN.y * 0.85, randf_range(0.2, 1.0)))


# This runs about 60 times every second.
func _process(delta: float) -> void:
	# Arrow keys move Night.
	var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	night_pos += dir * SPEED * delta
	night_pos.x = clampf(night_pos.x, 150, SCREEN.x - 120)
	night_pos.y = clampf(night_pos.y, 100, SCREEN.y - 50)

	flap += delta * 8.0

	# Clouds slide left so it looks like we're flying right.
	for i in clouds.size():
		var c: Vector3 = clouds[i]
		c.x -= (120.0 + 300.0 * c.z) * delta
		if c.x < -200:
			c.x = SCREEN.x + 200
			c.y = randf() * SCREEN.y * 0.85
		clouds[i] = c

	queue_redraw()


func _draw() -> void:
	# Sky: dark blue at the top, orange sunset at the bottom.
	var top := Color("#10183a")
	var bottom := Color("#e0703a")
	draw_polygon(
		PackedVector2Array([Vector2.ZERO, Vector2(SCREEN.x, 0), SCREEN, Vector2(0, SCREEN.y)]),
		PackedColorArray([top, top, bottom, bottom]))

	for c in clouds:
		var col := Color(1, 1, 1, 0.12 + 0.25 * c.z)
		var s: float = 25.0 + 45.0 * c.z
		draw_circle(Vector2(c.x, c.y), s, col)
		draw_circle(Vector2(c.x + s, c.y + s * 0.2), s * 0.8, col)
		draw_circle(Vector2(c.x - s, c.y + s * 0.25), s * 0.7, col)

	draw_night(night_pos)


# Draws a shape at position p out of a list of corner points.
func shape(p: Vector2, pts: Array, col: Color) -> void:
	var arr := PackedVector2Array()
	for v in pts:
		arr.append(p + v)
	draw_colored_polygon(arr, col)


func draw_night(p: Vector2) -> void:
	var black := Color("#121216")
	var dark := Color("#26262e")
	var green := Color("#3dff7e")
	var wing := sin(flap) * 40.0

	# Back wing (a bit lighter so you can see it)
	shape(p, [Vector2(-5, -10), Vector2(-50, -70 - wing * 0.6), Vector2(25, -14)], dark)

	# Tail
	shape(p, [Vector2(-40, -10), Vector2(-125, 8), Vector2(-40, 14)], black)
	shape(p, [Vector2(-118, 8), Vector2(-145, -12), Vector2(-140, 26)], black)

	# Body (a squashed circle)
	draw_set_transform(p, 0, Vector2(1.6, 0.8))
	draw_circle(Vector2.ZERO, 40, black)
	draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)

	# Neck, head, snout, horns
	shape(p, [Vector2(35, -20), Vector2(60, -35), Vector2(70, -10), Vector2(45, 10)], black)
	draw_circle(p + Vector2(66, -22), 22, black)
	shape(p, [Vector2(76, -34), Vector2(110, -16), Vector2(76, -6)], black)
	shape(p, [Vector2(54, -38), Vector2(44, -64), Vector2(66, -40)], dark)
	shape(p, [Vector2(64, -40), Vector2(62, -62), Vector2(74, -40)], dark)

	# Glowing green eye
	draw_circle(p + Vector2(76, -24), 6, green)
	draw_circle(p + Vector2(78, -24), 2.5, Color.BLACK)

	# Front wing
	shape(p, [Vector2(-20, -14), Vector2(-45, -95 - wing), Vector2(15, -78 - wing), Vector2(32, -16)], black)

	# Hu riding on top: brown overalls, green shirt
	var brown := Color("#7a4a22")
	var shirt := Color("#2f9e44")
	var skin := Color("#f1c27d")
	draw_rect(Rect2(p + Vector2(4, -44), Vector2(16, 14)), brown)     # legs
	draw_rect(Rect2(p + Vector2(4, -66), Vector2(16, 24)), shirt)     # shirt
	draw_rect(Rect2(p + Vector2(7, -60), Vector2(10, 18)), brown)     # overalls
	draw_circle(p + Vector2(12, -76), 10, skin)                       # head
	shape(p, [Vector2(2, -80), Vector2(12, -90), Vector2(23, -80), Vector2(12, -83)], Color("#5a3a1a"))  # hair
