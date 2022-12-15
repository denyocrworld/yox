from PIL import Image, ImageFont, ImageDraw

# original image
img = Image.open('1.png')
# converted to have an alpha layer
im2 = img.convert('RGBA')
# rotated image
rot = im2.rotate(22.2, expand=1)
# a white image same size as rotated image
fff = Image.new('RGBA', rot.size, (255,)*4)
# create a composite image using the alpha layer of rot as a mask
out = Image.composite(rot, fff, rot)
# save your work (converting back to mode='1' or whatever..)
out.convert(img.mode).save('1x.png')

# out.show()


impreview = Image.open('preview1.png')
_, _, _, alpha = out.split()
impreview.paste(out,(10,10),mask=alpha)
impreview.show()