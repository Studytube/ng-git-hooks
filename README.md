# README

To install git hooks for Studytube Angular app add `postinstall` script to the app's `package.json`:

```
"scripts": {
    "postinstall": "./node_modules/ng-git-hooks/setup-hooks.sh",
    ...
},
```
