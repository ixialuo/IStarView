#ReadMe
**邮箱：ixialuo@126.com**
**QQ：2256472253**
关于Bug反馈、以及好的建议，请大家提交到 Github 上，我会尽快解决。


#概述
经常在很多APP上可以看到各种评分五角星显示，那么该如何去做呢？大多数大家都是通过三种不同的ICON图片来设置，这样往往嵌入到项目时需要切图改名称等一列过程，在这里提供了原生的绘图法绘制出五角星，高亮和默认颜色仅仅只需要两句代码就可以完成。

#快速集成
IStarView支持使用Cocoapods集成，请在Podfile中添加以下语句：
```ruby
pod 'IStarView', '~> 0.0.3'
```
#使用实例
let starView = IStarView(frame: CGRect(x: 0, y: 0, width: 100, height: 80))
starView.value = 0.8
starView.center = view.center
starView.fillLightedColor = UIColor.red
starView.fillDefaultColor = UIColor.blue
view.addSubview(starView)
