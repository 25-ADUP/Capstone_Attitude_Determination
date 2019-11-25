
import bpy
from math import radians
from mathutils import Matrix
dir="home/randall/Model_Name/"
model="Model_Name"
obj = bpy.context.active_object
step_count = 36
step_count1 = 18
for step in range(0,step_count):
	bpy.data.scenes["Scene"].render.filepath=dir+model+"_"+str(step*10)+"_"+str(0)+".png"
	bpy.ops.render.render(write_still=True)
	for step1 in range(0,step_count1):
		rot_mat1 = Matrix.Rotation(radians(10), 4, 'Y')
		orig_loc1, orig_rot1, orig_scale1 = obj.matrix_world.decompose()
		orig_loc_mat1 = Matrix.Translation(orig_loc1)
		orig_rot_mat1 = orig_rot1.to_matrix().to_4x4()
		orig_scale_mat1 = Matrix.Scale(orig_scale1[0],4,(1,0,0)) @ Matrix.Scale(orig_scale1[1],4,(0,1,0)) @ Matrix.Scale(orig_scale1[2],4,(0,0,1))
		obj.matrix_world = orig_loc_mat1 @ rot_mat1 @ orig_rot_mat1 @ orig_scale_mat1
		bpy.data.scenes["Scene"].render.filepath=dir+model+"_"+str(step*10)+"_"+str((step1*10)+10)+".png"
		bpy.ops.render.render(write_still=True)
	rot_mat1 = Matrix.Rotation(radians(180), 4, 'Y')
	orig_loc1, orig_rot1, orig_scale1 = obj.matrix_world.decompose()
	orig_loc_mat1 = Matrix.Translation(orig_loc1)
	orig_rot_mat1 = orig_rot1.to_matrix().to_4x4()
	orig_scale_mat1 = Matrix.Scale(orig_scale1[0],4,(1,0,0)) @ Matrix.Scale(orig_scale1[1],4,(0,1,0)) @ Matrix.Scale(orig_scale1[2],4,(0,0,1))
	obj.matrix_world = orig_loc_mat1 @ rot_mat1 @ orig_rot_mat1 @ orig_scale_mat1
	rot_mat = Matrix.Rotation(radians(10), 4, 'X')
	orig_loc, orig_rot, orig_scale = obj.matrix_world.decompose()
	orig_loc_mat = Matrix.Translation(orig_loc)
	orig_rot_mat = orig_rot.to_matrix().to_4x4()
	orig_scale_mat = Matrix.Scale(orig_scale[0],4,(1,0,0)) @ Matrix.Scale(orig_scale[1],4,(0,1,0)) @ Matrix.Scale(orig_scale[2],4,(0,0,1))
	obj.matrix_world = orig_loc_mat @ rot_mat @ orig_rot_mat @ orig_scale_mat


