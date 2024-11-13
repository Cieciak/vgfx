module gfxe

pub struct LocalContex{
	pub mut:
		offset Vector2
		scale  f32
}

pub fn (root LocalContex) combine(other LocalContex) LocalContex{
	return LocalContex{
		offset: root.offset + other.offset.scale(root.scale)
		scale: root.scale * other.scale
	}
}