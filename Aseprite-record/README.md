# Record for Aseprite

一个 Aseprite 实用程序脚本，用于在应用程序中记录快照以构建时间流逝。

## How to Install

建议去工具的itch页面获取最新的稳定版本：https://sprngr.itch.io/aseprite-record  
克隆此仓库并将该目录复制到您的 Aseprite 脚本目录中。
## Scripts

（我不喜欢脚本文件的名称中有空格，但它使它在 Aseprite 菜单中看起来好多了。）

### Automatic Snapshot

此选项将打开一个对话框，提供按时间间隔拍摄快照的功能。

它需要有一个活动和保存的精灵才能运行。保存发生的时间间隔基于 [sprite change events](https://github.com/aseprite/api/blob/main/api/sprite.md#spriteevents) - 当对精灵进行更改时，包括撤消/重做操作。

间隔可在对话框中配置，数字越小意味着快照越频繁。如果您更改应用程序中的活动精灵，自动快照将保留对目标精灵的缓存引用，直到您使用对话框定位新精灵。 Command Palette 和 Take Snapshot 命令的用法可以在运行时并行使用。

### Command Palette

此选项将打开一个对话框以保留在您的编辑器中，让您可以访问拍摄快照的功能并打开当前精灵的时间间隔（如果为它保存了任何快照）。
下面详细描述了每个按钮的功能，并且可以作为可以映射到键盘快捷键的单个操作使用。

### Take Snapshot

此选项保存当前精灵可见层的扁平 png 副本。它被保存到一个名为`<name of sprite>__record`的同级文件夹. 每个文件将被保存，并在其末尾附加一个递增计数。此脚本不会对您的工作进行任何修改，它只会创建新文件。

### Open Time Lapse

这将打开 Aseprite 对话框，询问您是否希望加载所有与 gif 相关的序列文件。如果您接受，它将加载它作为为当前精灵保存的所有快照的酷时间流逝。

## Contributing

如果有任何贡献，请确保添加/修改的代码与[LuaRocks Lua Style Guide](https://github.com/luarocks/lua-style-guide).