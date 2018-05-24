# Template.apex
Template.apex is a library to evaluate templates written in visualforce expression syntax.

## Why Template.apex?
Sometimes we have the need to provide support for customizable templates like email templates. In these situations, Template.apex can help you evaluate templates written in visualforce expression syntax, which is handy and easy to pick up for those experienced in Salesforce visualforce pages.

## Dependencies
Template.apex has a dependency over [R.apex](https://github.com/Click-to-Cloud/R.apex/) and [Script.apex](https://github.com/Click-to-Cloud/Script.apex/).

Please include them before including Template.apex.

## Preliminary Knowledge
Template.apex uses Funcs from R.apex as the callback mechanism. If you want to go deeper with Template.apex, please do check out [R.apex](https://github.com/Click-to-Cloud/R.apex/).

## Examples
### Evaluate Templates
To evaluate a template written in visualforce expression syntax, what you need is only one line.

```java
String output = new Template().evaluate('Hi {! UPPER(acc.Name) }', new Map<String, Object>{ 'acc' => new Account(...) };
```
