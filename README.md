# SwiftBar Bookmarks Plugin

A tiny [SwiftBar](https://github.com/swiftbar/SwiftBar) plugin that puts your favourite URLs one click away in the macOS menubar.

## Features

- Click any bookmark to open it in your default browser.
- Add new bookmarks via a native prompt (name + URL).
- Remove bookmarks from a submenu.
- Plain-text storage, easy to hand-edit.

## Install

1. Install [SwiftBar](https://github.com/swiftbar/SwiftBar).
2. Clone this repo somewhere:
   ```
   git clone git@github.com:ZukkyBaig/swiftbar-bookmark-plugin.git
   ```
3. In SwiftBar, set the plugin folder to `swiftbar-bookmark-plugin/plugins`.
4. The bookmark icon appears in your menubar.

## Usage

- **Open a bookmark:** click its name in the dropdown.
- **Add:** click `Add bookmark...`, enter a name and URL. If you omit `https://`, it is added for you.
- **Remove:** open the `Remove bookmark` submenu and click the entry to delete.
- **Edit manually:** click `Edit file...` to open the storage file in your default editor.

## Storage

Bookmarks live in `bookmarks.txt` next to the plugins folder, one per line:

```
Netflix | https://www.netflix.com/
GitHub | https://github.com/
```

## License

MIT
