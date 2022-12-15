## How to Install Yo
```
flutter pub global activate yo
flutter pub global run yo
```

Restart Command Prompt
Run this command to test:
```
yo
``` 

## Create yox Project
```
yox init
```


## Create Module
```
yox module create [module_name]
```

example:
```
yox module create product
```

```
yox module create product/product_list
yox module create product/product_form
```

## Generate Icon
1. Update icon file in assets/icon/icon.png
2. Run this command:
```
yox generate_icon
```

## Remove Unused Import
```
yox clean
```


## Generate core.dart File
```
yox core
```