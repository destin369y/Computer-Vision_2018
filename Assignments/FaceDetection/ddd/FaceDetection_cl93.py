#COMP 546
#Face Detection
#Chengyin Liu, cl93

#https://docs.opencv.org/3.0-beta/doc/py_tutorials/py_setup/py_setup_in_windows/py_setup_in_windows.html

import numpy as np
import cv2

# Load an color image in grayscale
img = cv2.imread('Rice.jpg', 1)

cv2.imshow('image',img)
cv2.waitKey(0)
cv2.destroyAllWindows()

cap = cv2.VideoCapture(0)  
fps = cap.get(cv2.CAP_PROP_FPS)  
size = (int(cap.get(cv2.CAP_PROP_FRAME_WIDTH)),int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT)))  
fourcc = cv2.VideoWriter_fourcc('I','4','2','0')  
video = cv2.VideoWriter("D:\course\Rice\COMP546\Assignment Files\FinalExam\ddd\FaceDetection_cl93.avi", fourcc, 5, size)  
print cap.isOpened()  
  
classifier=cv2.CascadeClassifier("D:\library\openCV\opencv\sources\data\haarcascades\haarcascade_frontalface_alt.xml")  
  
count=0  
while count > -1:  
    ret,img = cap.read()  
    faceRects = classifier.detectMultiScale(img, 1.2, 2, cv2.CASCADE_SCALE_IMAGE,(20,20))  
    if len(faceRects)>0:  
        for faceRect in faceRects:   
                x, y, w, h = faceRect  
                cv2.rectangle(img, (int(x), int(y)), (int(x)+int(w), int(y)+int(h)), (0,255,0),2,0)  
    video.write(img)  
    cv2.imshow('video',img)  
    key=cv2.waitKey(1)  
    if key==ord('q'):  
        break  
  
video.release()  
cap.release()  
cv2.destroyAllWindows()

