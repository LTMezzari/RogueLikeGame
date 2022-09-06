tool
class_name LootTable extends Node2D

const LootRes = preload("res://Components/LootTable/Loot/Loot.tres")

export(int) var max_drops: int = 1
export(Array, Resource) var possible_loot := [] setget set_possible_loot

func set_possible_loot(value: Array) -> void:
	possible_loot.resize(value.size())
	possible_loot = value
	for i in value.size():
		if (possible_loot[i]):
			continue
		possible_loot[i] = LootRes.duplicate()
		possible_loot[i].resource_name = "Loot " + str(i + 1)

func drop_loot() -> Array:
	var loot := roll_loot()
	var loot_items := []
	for item in loot:
		var num := int(ceil(randi() % item.max_drop + item.min_drop))
		for i in num:
			var instance := _create_node(item.drop)
			_place_node(item)
			loot_items.append(item)
	return loot_items
	pass

func roll_loot() -> Array:
	var drops := []
	for loot in possible_loot.shuffle():
		if (drops.size() >= max_drops):
			break
		
		if (not (loot is Loot) || loot == null):
			continue
		
		var chance := min(max(0, loot.chance), 1)
		if (rand_range(0, 1) > chance):
			continue
		drops.append(loot)
	return drops
	pass

func _create_node(loot: PackedScene) -> Node:
	return loot.instance()
	pass

func _place_node(node: Node) -> void:
	var parent = get_tree().current_scene
	parent.add_child(node)
	node.global_position = global_position
	pass
