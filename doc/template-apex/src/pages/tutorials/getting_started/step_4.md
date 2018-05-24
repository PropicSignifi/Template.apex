---
title: "Customization"
description: "Customization"
buttonTitle: "Done"
parentId: "getting_started"
layout: "tutorial"
time: 90
weight: 4
---

## {$page.title}

You can create a Template with options to customize it.

```javascript
Template.Options opts = new Template.Options();
opts.expressionStart = '{{';
opts.expressionEnd = '}}';
Template t = new Template(opts);
```
