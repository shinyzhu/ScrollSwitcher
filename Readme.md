# ScrollSwitcher #

A simple visual number switcher, you can use it for temperature selector of air conditioner.

## NumberSwitcher is the only control ##

Use the NumberSwitcher control just like:

``` objective-c
    NumberSwitcher *zwitcher = [[NumberSwitcher alloc] initWithOrigin:CGPointMake(100, 100) 
                                                        minimumNumber:18 
                                                        maximumNumber:29 
                                                       selectedNumber:23];
    zwitcher.delegate = self;
```
Rendered like:

<img src="https://bitbucket.org/pluxs/scrollswitcher/raw/d9f3ad4bd1cd/src/ScrollSwitcher/capture.png" alt="ScrollSwitcher" title="ScrollSwitcher" style="display:block; margin: 10px auto 30px auto;" class="center">

Enjoy coding!