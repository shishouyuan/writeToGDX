# r = writeToGDX(filename,param)
A MATLAB function simplifies the work of writing data into GAMS GDX file. 

- Author：Shi Shouyuan @ South China University of Technology
- E-mail：shishouyuan@outlook.com


## Parameter Discription：
- **filename:**
The target GDX file name.
- **param：**
    - **Format 1：** A char array, gives the prefix that indicates which variables in MATLAB workspace need to be written to GDX file.
    - **Format 2：** A structure, contains all parameters need to be written to GDX file.
- **r:**
Return the code for GAMS to load these parameters just written to GDX file, for example：
```
     $GDXIN abc.gdx
     $Load Power=Power
     $Load Power2=Power2
     $GDXIN
     ;
```

# Usage of the 2 Formats：
## Format 1: Prefixing
Name all the parameters need to be written to GDX file as follow:
```
prefix_dimension_nameInGDX
```
### Example：
```
 prefix='GDX';
 GDX_2_Power=[1,2;3,4];
 GDX_2_Power2=[1,2;3,4];
 writeToGDX('abc.gdx',prefix)
```
## Format 2: Structuring
Put every parameter need to be written to GDX file into a structure, with each element named as follow:
```
nameInGDX_dimension
```
### Example：
```
p.Power1_0=1;
p.Power2_2=[1,2;3,4];
writeToGDX('abc.gdx',p)
```

# r = writeToGDX(filename,param) 
一个可以简化写入GAMS GDX文件工作的MATLAB函数。
- 作者：史守圆 @ 华南理工大学
- 邮箱：shishouyuan@outlook.com

## 参数说明：
- **filename:**
要写入的GDX文件名
- **param：**
    - **格式一：** 变量前缀，用来标识要写入的变量
    - **格式二：** 包含所有要写入的变量的结构体
- **r:**
返回GAMS用于导入参数的命令，如：
```
     $GDXIN abc.gdx
     $Load Power=Power
     $Load Power2=Power2
     $GDXIN
     ;
```

# 2种格式的使用方法：
## 格式一：前缀形式
将要写入GDX的变量均以下面的格式命名路径即可
```
prefix_维数_GDX中的参数名
```
### 例子：
```
 prefix='GDX';
 GDX_2_Power=[1,2;3,4];
 GDX_2_Power2=[1,2;3,4];
 writeToGDX('abc.gdx',prefix)
```
## 格式二：结构体形式
将要写入GDX的变量放入一个结构体中，结构体域按下面的格式命名即可
```
GDX中的参数名_维数
```
### 例子：
```
p.Power1_0=1;
p.Power2_2=[1,2;3,4];
writeToGDX('abc.gdx',p)
```
