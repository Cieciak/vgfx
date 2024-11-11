module gfxe

@[heap]
pub struct Layer{
	mut:
		objects []LayerObject
}

pub fn (mut lr Layer) add_simple(obj Simple){
	lr.objects << SimpleStruct{s: obj}
}

pub fn (mut lr Layer) add_complex(obj Complex){
	lr.objects << ComplexStruct{c: obj}
}