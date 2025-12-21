@tool
class_name PiramidalContainer
extends Container

# -------------------------
# Editable configuration
# -------------------------
@export var columns: int = 3:
	set(value):
		columns = max(1, value)
		_force_sort()

@export var h_spacing: float = 20:
	set(value):
		h_spacing = max(0, value)
		_force_sort()

@export var v_spacing: float = 20:
	set(value):
		v_spacing = max(0, value)
		_force_sort()

@export var side_offset: float = 20.0:
	set(value):
		side_offset = value
		_force_sort()

@export var center_offset: float = 10.0:
	set(value):
		center_offset = value
		_force_sort()

# -------------------------
# Initialization
# -------------------------
func _enter_tree():
	_force_sort()

func _ready():
	_force_sort()

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		_sort_children()
	elif what == NOTIFICATION_RESIZED or what == NOTIFICATION_CHILD_ORDER_CHANGED:
		_force_sort()

# -------------------------
# Force reordering in editor or runtime
# -------------------------
func _force_sort():
	if Engine.is_editor_hint():
		call_deferred("queue_sort")
	else:
		queue_sort()

# -------------------------
# Pyramid layout logic
# -------------------------
func _sort_children():
	if columns <= 0 or size.x <= 0:
		return

	# Filter only Control-type children
	var children := get_children().filter(func(c): return c is Control)
	if children.is_empty():
		return

	# Width of each cell including spacing
	var total_spacing := h_spacing * (columns - 1)
	var cell_width := (size.x - total_spacing) / columns

	for i in range(children.size()):
		var child: Control = children[i]
		var child_size := child.get_combined_minimum_size()

		var row := i / columns
		var col := i % columns

		# X position with horizontal spacing
		var x := col * (cell_width + h_spacing)

		# Y position with vertical spacing
		var y := row * (child_size.y + v_spacing)

		# Pyramid: center on top, side children lower
		if col == columns / 2:
			y -= center_offset
		else:
			y += side_offset

		# Set position and size of the child
		fit_child_in_rect(
			child,
			Rect2(Vector2(x, y), child_size)
		)
