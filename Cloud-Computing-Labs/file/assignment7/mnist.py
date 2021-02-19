import os
import tensorflow as tf
import matplotlib.pyplot as plt
import numpy as np

mnist = tf.keras.datasets.mnist
(x_train, y_train),(x_test, y_test) = mnist.load_data(path="/data/data/mnist.npz")   #加载mnist数据集

#验证mnist数据集大小。x为数据，y为标签。mnist每张图的像素为28*28
print(x_train.shape)
print(y_train.shape)
print(x_test.shape)
print(y_test.shape)

#打印训练集中前9张，看看是什么数字
for i in range(9):  
    plt.subplot(3,3,1+i)
    plt.imshow(x_train[i], cmap='gray')
plt.show()

#打印相应的标签
print(y_train[:9])

#基操：将像素标准化一下
x_train, x_test = x_train / 255.0, x_test / 255.0

#搭建一个两层神经网络
model = tf.keras.models.Sequential([
  tf.keras.layers.Flatten(input_shape=(28, 28)),    #拉伸图像成一维向量
  tf.keras.layers.Dense(128, activation='relu'),    #第一层全连接+ReLU激活
  tf.keras.layers.Dropout(0.2),                     #dropout层
  tf.keras.layers.Dense(10, activation='softmax')   #第二层全连接+softmax激活，输出预测标签
])

#设置训练超参，优化器为sgd，损失函数为交叉熵，训练衡量指标为accuracy
model.compile(optimizer='sgd', loss='sparse_categorical_crossentropy', metrics=['accuracy'])

#开始训练，训练5个epoch，一个epoch代表所有图像计算一遍。每一个epoch能观察到训练精度的提升
model.fit(x_train, y_train, epochs=5)

#计算训练了5个epoch的模型在测试集上的表现
model.evaluate(x_test,  y_test)


#直观看一下模型预测结果，打印测试集中的前9张图像
for i in range(9):  
    plt.subplot(3,3,1+i)
    plt.imshow(x_test[i], cmap='gray')
plt.show()

#打印模型识别的数字，是否正确？
np.argmax(model(x_test[:9]).numpy(), axis=1)

#保存训练好的模型
model.save("/data/output/model_epoch_5")