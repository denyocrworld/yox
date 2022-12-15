# required
# pip install opencv-python
#
# generate exe files
# pip install pyinstaller
# pyinstaller autocrop.py --onefile

# python -m pip install --upgrade Pillow

import cv2
import os
import imutils
from scipy import ndimage

def resize_image():
    arr = os.listdir()
    for filename in arr:
        if(filename.endswith(".jpg") or filename.endswith(".png")):
            print(filename)
            img = cv2.imread(filename)
            height, width, channels = img.shape


            # 720x1640
            if(height == 1640):
                print(filename)
                y = 80
                h = 1640-160
                x = 0
                w = 720

                directory = str(w) + 'x' + str(h)
                if not os.path.exists(directory):
                    os.makedirs(directory)
                
                crop_img = img[y:y+h, x:x+w]
                cv2.imwrite(directory + '/' + filename,crop_img)
                print(filename + " images resized")


def merge_image(back, front, x,y):
    # convert to rgba
    if back.shape[2] == 3:
        back = cv2.cvtColor(back, cv2.COLOR_BGR2BGRA)
    if front.shape[2] == 3:
        front = cv2.cvtColor(front, cv2.COLOR_BGR2BGRA)

    # crop the overlay from both images
    bh,bw = back.shape[:2]
    fh,fw = front.shape[:2]
    x1, x2 = max(x, 0), min(x+fw, bw)
    y1, y2 = max(y, 0), min(y+fh, bh)
    front_cropped = front[y1-y:y2-y, x1-x:x2-x]
    back_cropped = back[y1:y2, x1:x2]

    alpha_front = front_cropped[:,:,3:4] / 255
    alpha_back = back_cropped[:,:,3:4] / 255
    
    # replace an area in result with overlay
    result = back.copy()
    print(f'af: {alpha_front.shape}\nab: {alpha_back.shape}\nfront_cropped: {front_cropped.shape}\nback_cropped: {back_cropped.shape}')
    result[y1:y2, x1:x2, :3] = alpha_front * front_cropped[:,:,:3] + (1-alpha_front) * back_cropped[:,:,:3]
    result[y1:y2, x1:x2, 3:4] = (alpha_front + alpha_back) / (1 + alpha_front*alpha_back) * 255

    return result


def generate_preview():
    im1 = cv2.imread('preview1.png')
    im2 = cv2.imread('1.png')

    im2 = ndimage.rotate(im2, 25)

    res = merge_image(im1,im2,200,100)
    cv2.imwrite("preview1x.png",res)

generate_preview()
