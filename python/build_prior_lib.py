import bpy
from math import radians
from mathutils import Matrix
from modelstorage import ModelStorage
from PIL import Image
import io

dir = "home/randall/Model_Name"
model = "Model_Name"
obj = bpy.context.active_object
step_count = 36
step_count1 = 18

with ModelStorage(drop_old=True) as db:
    for step in range(0, step_count):
        filename = '{}/{}_{}_0}.png'.format(dir, model, step * 10)
        bpy.data.scenes["Scene"].render.filepath = filename
        bpy.ops.render.render(write_still=True)

        # convert image to greyscale and prep for storage
        im = Image.open(filename).convert('L')
        file_ob = io.BytesIO()
        im.save(file_ob, format='PNG')

        # save and close byte buffer
        db.insert(step, 0, 0, file_ob)
        file_ob.close()

        for step1 in range(0, step_count1):
            rot_mat1 = Matrix.Rotation(radians(10), 4, 'Y')
            orig_loc1, orig_rot1, orig_scale1 = obj.matrix_world.decompose()
            orig_loc_mat1 = Matrix.Translation(orig_loc1)
            orig_rot_mat1 = orig_rot1.to_matrix().to_4x4()

            orig_scale_mat1 = Matrix.Scale(orig_scale1[0], 4, (1, 0, 0)) \
                              @ Matrix.Scale(orig_scale1[1], 4, (0, 1, 0)) \
                              @ Matrix.Scale(orig_scale1[2], 4, (0, 0, 1))

            obj.matrix_world = orig_loc_mat1 @ rot_mat1 @ orig_rot_mat1 @ orig_scale_mat1

            filename = '{}/{}_{}_{}.png'.format(dir, model, step * 10, (step1 * 10) + 10)
            bpy.data.scenes["Scene"].render.filepath = filename
            bpy.ops.render.render(write_still=True)

            # convert image to greyscale and prep for storage
            im = Image.open(filename).convert('L')
            file_ob = io.BytesIO()
            im.save(file_ob, format='PNG')

            # save and close byte buffer
            db.insert(step, step1, 0, file_ob)
            file_ob.close()

        rot_mat1 = Matrix.Rotation(radians(180), 4, 'Y')
        orig_loc1, orig_rot1, orig_scale1 = obj.matrix_world.decompose()
        orig_loc_mat1 = Matrix.Translation(orig_loc1)
        orig_rot_mat1 = orig_rot1.to_matrix().to_4x4()

        orig_scale_mat1 = Matrix.Scale(orig_scale1[0], 4, (1, 0, 0)) \
                          @ Matrix.Scale(orig_scale1[1], 4, (0, 1, 0)) \
                          @ Matrix.Scale(orig_scale1[2], 4, (0, 0, 1))

        obj.matrix_world = orig_loc_mat1 @ rot_mat1 @ orig_rot_mat1 @ orig_scale_mat1
        rot_mat = Matrix.Rotation(radians(10), 4, 'X')
        orig_loc, orig_rot, orig_scale = obj.matrix_world.decompose()
        orig_loc_mat = Matrix.Translation(orig_loc)
        orig_rot_mat = orig_rot.to_matrix().to_4x4()

        orig_scale_mat = Matrix.Scale(orig_scale[0], 4, (1, 0, 0)) \
                         @ Matrix.Scale(orig_scale[1], 4, (0, 1, 0)) \
                         @ Matrix.Scale(orig_scale[2], 4, (0, 0, 1))

        obj.matrix_world = orig_loc_mat @ rot_mat @ orig_rot_mat @ orig_scale_mat
