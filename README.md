# CircleOfFriendsDisplay
朋友圈的做法

![展示图](https://github.com/liyuunxiangGit/CircleOfFriendsDisplay/blob/master/111.gif)
##[我的博客](http://blog.csdn.net/liyunxiangrxm)
##运用MVC设计模式
###`MVC` 是苹果公司最热衷的一种架构模式<br>
* `M`: model的缩写  模型层的简称<br>
 * model层用来存放整个工程中需要的所有数据 (实体类的创建、数据的请求、数据持久性存储等操作都是写在model层的)<br>
* `C`: controller的缩写 控制层的简称<br>
 * controller层用来将model上的数据显示在view上（controller层实时监控model上的数据变化 指挥view视图显示model上的数据）<br>
* 【注意】model层和view视图不能直接通信 必须借助controller层<br>
* `V`: view的缩写 视图层的简称<br>
 * view层主要听从controller的指挥显示model层的数据<br>
