# README

To install git hooks for Studytube Angular app:

1. Add `ng-git-hooks` to the app dev dependencies
```
npm install --save-dev git+ssh://git@github.com:StudyTube/ng-git-hooks.git#1.0.0
```

2. Update `postinstall` script in the app's `package.json`

```
"scripts": {
    "postinstall": "./node_modules/ng-git-hooks/setup-hooks.sh",
    ...
},
```
